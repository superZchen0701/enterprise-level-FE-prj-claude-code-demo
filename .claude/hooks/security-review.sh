#!/bin/bash
# Git 安全审查脚本
# 检查代码中的敏感信息泄露、安全漏洞和编码最佳实践
# 规范来源：@docs/ai-context/coding-standards.md

echo "=== 执行安全审查 ==="

# 定位 git 仓库根目录
GIT_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || echo "$(cd "$(dirname "$0")" && pwd)")"
echo "仓库根目录：$GIT_ROOT"
cd "$GIT_ROOT"

# 累计问题数
HIGH_COUNT=0
MEDIUM_COUNT=0
LOW_COUNT=0
SCANNED_FILES=0
TOTAL_FILES=0

# 临时文件存放扫描结果
REPORT_FILE=$(mktemp)
FILE_LIST=$(mktemp)

# 清理临时文件
cleanup() {
  rm -f "$REPORT_FILE" "$FILE_LIST"
}
trap cleanup EXIT

# ==================== 获取待扫描文件列表 ====================

# 获取待扫描文件列表：已跟踪 + 未跟踪（排除 .gitignore）
{
  git ls-files --cached 2>/dev/null
  git ls-files --others --exclude-standard 2>/dev/null
} | sort -u > "$FILE_LIST"

# 排除无需扫描的文件/目录
filter_files() {
  local tmp="$1"
  grep -v 'node_modules/' "$tmp" | \
    grep -v '/dist/' | \
    grep -v '\.git/' | \
    grep -v 'coverage/' | \
    grep -v '\.DS_Store' | \
    grep -v '\.env\.local' | \
    grep -v '\.env\..*\.local' | \
    grep -v 'npm-debug\.log' | \
    grep -v 'yarn-debug\.log' | \
    grep -v 'yarn-error\.log' | \
    grep -v 'pnpm-debug\.log' | \
    grep -v '\.idea/' | \
    grep -v '\.vscode/' | \
    grep -v '\.suo$' | \
    grep -v '\.ntvs' | \
    grep -v '\.njsproj$' | \
    grep -v '\.sln$' | \
    grep -v '\.sw.' | \
    \
    grep -v 'package-lock\.json$' | \
    grep -v 'package\.json$' | \
    \
    grep -v '\.claude/' | \
    grep -v 'openspec/' | \
    grep -v 'docs/' | \
    \
    grep -v '\.md$' | \
    grep -v '\.yaml$' | \
    grep -v '\.yml$' | \
    grep -v '\.env\.example$' | \
    \
    grep -v 'babel\.config\.js$' | \
    grep -v 'jsconfig\.json$' | \
    grep -v 'vue\.config\.js$' | \
    grep -v '\.gitignore$' | \
    grep -v '\.mcp\.json$' | \
    \
    grep -v '\.png$' | \
    grep -v '\.ico$' | \
    grep -v '\.svg$' | \
    grep -v '\.jpe\?g$' | \
    grep -v '\.gif$' | \
    grep -v '\.bmp$' | \
    \
    grep -v '\.woff2\?$' | \
    grep -v '\.ttf$' | \
    grep -v '\.eot$'
}

filter_files "$FILE_LIST" > "${FILE_LIST}.filtered"
mv "${FILE_LIST}.filtered" "$FILE_LIST"

TOTAL_FILES=$(wc -l < "$FILE_LIST")

if [ "$TOTAL_FILES" -eq 0 ]; then
  echo "没有需要扫描的变更文件"
  exit 0
fi

echo "待扫描文件数：$TOTAL_FILES"
echo ""
echo "扫描文件列表:"
cat "$FILE_LIST"
echo ""

# ==================== 扫描函数 ====================

# 输出一条问题
# 参数: 等级(高/中/低) 文件 行号 类型 描述 建议
record_issue() {
  local level="$1" file="$2" line="$3" type="$4" desc="$5" suggestion="$6"
  case "$level" in
    高) level_label="🔴 高风险";;
    中) level_label="🟡 中风险";;
    低) level_label="🟢 低风险";;
  esac
  echo "[$level_label] $file:$line - $type: $desc → $suggestion" >> "$REPORT_FILE"
}

# 扫描单个文件的通用函数
# 参数: 文件路径
scan_file() {
  local file="$1"
  SCANNED_FILES=$((SCANNED_FILES + 1))

  # ---- 2.1 敏感信息检查 ----

  # API 密钥（排除环境变量引用）
  local matches
  matches=$(grep -nI 'API_KEY\|API_SECRET\|apikey\|api_secret' "$file" 2>/dev/null | grep -v 'process\.env' | grep -v 'VUE_APP_' | grep -v 'import\|require\|defineProps\|props')
  if [ -n "$matches" ]; then
    echo "$matches" | while IFS=: read -r line content; do
      record_issue "高" "$file" "$line" "硬编码API密钥" "发现疑似硬编码的API密钥" "改用环境变量，通过 process.env.VUE_APP_XXX 引用"
    done
  fi

  # 密码
  matches=$(grep -nI 'PASSWORD\|PASSWD\|pwd\|password' "$file" 2>/dev/null | grep -v 'process\.env' | grep -v 'VUE_APP_' | grep -v '^\s*//\|^\s*#\|^\s*\*')
  if [ -n "$matches" ]; then
    echo "$matches" | while IFS=: read -r line content; do
      record_issue "高" "$file" "$line" "硬编码密码" "发现疑似硬编码的密码字段" "改用环境变量管理敏感凭据"
    done
  fi

  # Token / Secret
  matches=$(grep -nI 'TOKEN\|SECRET_TOKEN\|access_token\|refresh_token\|secret_key\|SECRET_KEY' "$file" 2>/dev/null | grep -v 'process\.env' | grep -v 'VUE_APP_' | grep -v 'import\|require' | grep -v '^\s*//\|^\s*\*')
  if [ -n "$matches" ]; then
    echo "$matches" | while IFS=: read -r line content; do
      record_issue "高" "$file" "$line" "硬编码Token" "发现疑似硬编码的Token或密钥" "改用环境变量管理"
    done
  fi

  # 私钥
  if grep -qnI 'PRIVATE_KEY\|BEGIN.*PRIVATE' "$file" 2>/dev/null; then
    local priv_lines=$(grep -nI 'PRIVATE_KEY\|BEGIN.*PRIVATE' "$file" 2>/dev/null | cut -d: -f1)
    echo "$priv_lines" | while read -r line; do
      record_issue "高" "$file" "$line" "私钥泄露" "发现疑似硬编码的私钥" "私钥必须存放在密钥管理服务中，禁止出现在代码中"
    done
  fi

  # 数据库连接字符串（含密码）
  matches=$(grep -nI 'mongodb://\|mysql://\|postgres://\|jdbc:' "$file" 2>/dev/null | grep -v 'process\.env\|localhost\|127.0.0.1')
  if [ -n "$matches" ]; then
    echo "$matches" | while IFS=: read -r line content; do
      record_issue "高" "$file" "$line" "数据库连接串泄露" "发现疑似含凭据的数据库连接串" "使用环境变量存储数据库连接信息"
    done
  fi

  # AWS/Azure/GCP 密钥
  matches=$(grep -nI 'AKIA[0-9A-Z]\{16\}\|aws_secret\|AZURE_STORAGE_KEY\|gcp_credentials' "$file" 2>/dev/null | grep -v 'process\.env')
  if [ -n "$matches" ]; then
    echo "$matches" | while IFS=: read -r line content; do
      record_issue "高" "$file" "$line" "云服务凭证泄露" "发现疑似云服务AccessKey" "使用IAM角色或环境变量管理云服务凭证"
    done
  fi

  # ---- 2.2 安全漏洞检查 ----

  # XSS - v-html / innerHTML
  if grep -qn 'v-html\|innerHTML' "$file" 2>/dev/null; then
    local xss_lines=$(grep -n 'v-html\|innerHTML' "$file" 2>/dev/null | cut -d: -f1)
    echo "$xss_lines" | while read -r line; do
      record_issue "高" "$file" "$line" "XSS风险" "使用了 v-html 或 innerHTML，存在XSS风险" "优先使用文本插值或 v-text；若必须使用，确保内容已经过 DOMPurify 消毒"
    done
  fi

  # eval / Function 动态执行
  if grep -qn 'eval(\|new Function(' "$file" 2>/dev/null; then
    local eval_lines=$(grep -n 'eval(\|new Function(' "$file" 2>/dev/null | grep -v '^\s*//' | cut -d: -f1)
    echo "$eval_lines" | while read -r line; do
      record_issue "高" "$file" "$line" "动态代码执行" "使用了 eval() 或 new Function()，存在代码注入风险" "禁止使用动态代码执行，改用安全替代方案"
    done
  fi

  # 不安全的 HTTP 链接（非 localhost）
  matches=$(grep -nI 'http://' "$file" 2>/dev/null | grep -v 'localhost\|127.0.0.1\|http://10\.\|http://172\.\|http://192\.168\.\|//example\|//www.example\|placeholder')
  if [ -n "$matches" ]; then
    echo "$matches" | while IFS=: read -r line content; do
      record_issue "低" "$file" "$line" "不安全的HTTP链接" "使用了 http:// 非加密连接" "生产环境应使用 https://"
    done
  fi

  # SSL 验证禁用
  if grep -qn 'rejectUnauthorized.*false\|NODE_TLS_REJECT_UNAUTHORIZED.*0\|verify.*false' "$file" 2>/dev/null; then
    local ssl_lines=$(grep -n 'rejectUnauthorized.*false\|NODE_TLS_REJECT_UNAUTHORIZED.*0\|verify.*false' "$file" 2>/dev/null | grep -v '^\s*//\|^\s*\*' | cut -d: -f1)
    echo "$ssl_lines" | while read -r line; do
      record_issue "中" "$file" "$line" "SSL验证禁用" "发现 SSL/TLS 证书验证被禁用" "生产环境禁止禁用 SSL 验证，开发环境限定 localhost"
    done
  fi

  # 不安全的正则（用户输入直接放入new RegExp）
  matches=$(grep -n 'new RegExp(' "$file" 2>/dev/null | grep -v '^\s*//')
  if [ -n "$matches" ]; then
    echo "$matches" | while IFS=: read -r line content; do
      record_issue "中" "$file" "$line" "不安全的正则" "使用了 new RegExp()，若参数来自用户输入可能导致ReDoS" "对用户输入进行转义或限制正则复杂度"
    done
  fi

  # Math.random 用于安全场景
  matches=$(grep -nI 'Math\.random()' "$file" 2>/dev/null | grep -i 'token\|password\|secret\|key\|auth\|crypto\|hash\|salt')
  if [ -n "$matches" ]; then
    echo "$matches" | while IFS=: read -r line content; do
      record_issue "中" "$file" "$line" "弱随机数" "Math.random() 用于安全相关场景，随机性不足" "使用 crypto.randomBytes() 或 crypto.getRandomValues()"
    done
  fi

  # ---- 2.3 最佳实践检查 ----

  # console.log / console.debug（非测试文件）
  if echo "$file" | grep -qv 'test\|spec\|\.test\.\|\.spec\.\|node_modules'; then
    if grep -qn 'console\.log\|console\.debug' "$file" 2>/dev/null; then
      local cl_lines=$(grep -n 'console\.log\|console\.debug' "$file" 2>/dev/null | grep -v '^\s*//\|^\s*\*' | cut -d: -f1)
      echo "$cl_lines" | while read -r line; do
        record_issue "低" "$file" "$line" "残留调试代码" "存在 console.log/debug 语句" "生产构建前应移除调试日志，或使用统一的 logger 控制输出级别"
      done
    fi
  fi

  # debugger 语句
  if grep -qn 'debugger' "$file" 2>/dev/null; then
    local dbg_lines=$(grep -n 'debugger' "$file" 2>/dev/null | grep -v '^\s*//\|^\s*\*' | cut -d: -f1)
    echo "$dbg_lines" | while read -r line; do
      record_issue "中" "$file" "$line" "debugger语句" "代码中存在 debugger 断点" "提交前删除 debugger 语句"
    done
  fi

  # TODO/FIXME（记录但不计风险）
  matches=$(grep -nI 'TODO\|FIXME\|HACK\|XXX' "$file" 2>/dev/null | grep -v '^\s*//.*eslint' | head -20)
  if [ -n "$matches" ]; then
    echo "$matches" | while IFS=: read -r line content; do
      echo "[ℹ️ 待处理标记] $file:$line - $content" >> "$REPORT_FILE"
    done
  fi

  # eslint-disable
  if grep -qn 'eslint-disable\|eslint-ignore' "$file" 2>/dev/null; then
    local ed_lines=$(grep -n 'eslint-disable\|eslint-ignore' "$file" 2>/dev/null | cut -d: -f1)
    echo "$ed_lines" | while read -r line; do
      record_issue "低" "$file" "$line" "禁用ESLint" "使用了 eslint-disable/ignore 注释" "如非必要请移除，若确需保留请附加说明注释"
    done
  fi
}

# ==================== 执行扫描 ====================

while IFS= read -r file; do
  [ -z "$file" ] && continue
  [ ! -f "$file" ] && continue
  scan_file "$file"
done < "$FILE_LIST"

# 从报告文件中统计各等级问题数（解决 subshell 变量丢失问题）
if [ -s "$REPORT_FILE" ]; then
  HIGH_COUNT=$(grep -c '高风险\]' "$REPORT_FILE" 2>/dev/null)
  MEDIUM_COUNT=$(grep -c '中风险\]' "$REPORT_FILE" 2>/dev/null)
  LOW_COUNT=$(grep -c '低风险\]' "$REPORT_FILE" 2>/dev/null)
fi

echo ""
echo "=========================================="
echo "  安全审查报告"
echo "=========================================="
echo ""
echo "审查概览"
echo "  审查时间: $(date '+%Y-%m-%d %H:%M:%S')"
echo "  待扫描文件: $TOTAL_FILES"
echo "  已扫描文件: $SCANNED_FILES"
echo ""

# 输出问题详情
if [ -s "$REPORT_FILE" ]; then
  echo "发现的问题"
  echo "------------------------------------------"
  cat "$REPORT_FILE"
  echo "------------------------------------------"
else
  echo "未发现任何问题"
fi

echo ""
echo "统计汇总"
echo "  🔴 高风险: $HIGH_COUNT"
echo "  🟡 中风险: $MEDIUM_COUNT"
echo "  🟢 低风险: $LOW_COUNT"

# ==================== 输出扫描文件列表（CI/CD 友好） ====================

if [ "${CI:-false}" = "true" ]; then
  echo ""
  echo "扫描文件列表:"
  cat "$FILE_LIST"
fi

# ==================== 结束 ====================

echo ""
if [ "$HIGH_COUNT" -gt 0 ]; then
  echo "=== 安全审查未通过：发现 $HIGH_COUNT 个高风险问题 ==="
  exit 1
elif [ "$MEDIUM_COUNT" -gt 0 ]; then
  echo "=== 安全审查通过：存在 $MEDIUM_COUNT 个中风险问题，建议修复 ==="
  exit 0
else
  echo "=== 安全审查通过 ==="
  exit 0
fi
