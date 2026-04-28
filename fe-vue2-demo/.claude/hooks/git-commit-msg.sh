#!/bin/bash
# Git commit-msg hook
# 验证 commit message 是否符合项目规范
# 规范来源：@docs/ai-context/coding-standards.md

COMMIT_MSG_FILE=$1
COMMIT_MSG=$(cat "$COMMIT_MSG_FILE")

echo "=== 验证 Commit Message 格式 ==="

# 从 coding-standards.md 读取规范的 type 列表
# 如果文件不存在，使用默认 type 列表
HOOKS_DIR="$(cd "$(dirname "$0")" && pwd)"
# Git 仓库根目录的父目录（仓库根目录）
GIT_REPO_DIR="$(dirname "$(dirname "$HOOKS_DIR")")"

# 查找项目根目录
find_project_root() {
  # 检查是否在 monorepo 的子项目中
  if [ -d "$GIT_REPO_DIR/fe-vue2-demo" ]; then
    echo "$GIT_REPO_DIR/fe-vue2-demo"
    return 0
  fi

  # 检查 git root 是否有 docs/ai-context
  if [ -d "$GIT_REPO_DIR/docs/ai-context" ]; then
    echo "$GIT_REPO_DIR"
    return 0
  fi

  echo "$GIT_REPO_DIR"
}

PROJECT_ROOT=$(find_project_root)
STANDARDS_FILE="$PROJECT_ROOT/docs/ai-context/coding-standards.md"

if [ -f "$STANDARDS_FILE" ]; then
  # 从 markdown 中提取 type 列表
  # 匹配：- `feat`: 新功能
  TYPES=$(grep -E "^- \`(\w+)\`:" "$STANDARDS_FILE" 2>/dev/null | sed -E 's/- `(\w+)`: .*/\1/' | tr '\n' '|' | sed 's/|$//')
  FORMAT=$(grep -A1 "### 提交格式" "$STANDARDS_FILE" 2>/dev/null | grep -E "^\`\`\`" -A1 | tail -1 | tr -d '` ')
else
  TYPES="feat|fix|docs|style|refactor|test|chore"
  FORMAT="<type>(<tapdID>): <description>"
fi

# 如果提取失败，使用默认值
if [ -z "$TYPES" ]; then
  TYPES="feat|fix|docs|style|refactor|test|chore"
fi
if [ -z "$FORMAT" ]; then
  FORMAT="<type>(<tapdID>): <description>"
fi

# 构建正则表达式
# 格式：type(scope): description 或 type: description
REGEX="^($TYPES)(\(.+\))?: .+"

if echo "$COMMIT_MSG" | grep -qE "$REGEX"; then
  echo "✓ 格式正确：$COMMIT_MSG"
  echo "=== 验证通过 ==="
  exit 0
fi

# 验证失败
echo ""
echo "❌ 格式错误：$COMMIT_MSG"
echo ""
echo "正确格式：$FORMAT"
echo ""
echo "type 可选值:"
if [ -f "$STANDARDS_FILE" ]; then
  grep -E "^- \`(\w+)\`:" "$STANDARDS_FILE" 2>/dev/null | sed -E 's/- `(\w+)`: (.*)/  \1  \2/' | sed 's/&lt;/</g; s/&gt;/>/g'
else
  echo "  feat      新功能"
  echo "  fix       修复 bug"
  echo "  docs      文档更新"
  echo "  style     代码格式"
  echo "  refactor  重构"
  echo "  test      测试相关"
  echo "  chore     构建/工具相关"
fi
echo ""
echo "示例:"
echo "  feat(123): 添加用户登录功能"
echo ""
echo "详见：@docs/ai-context/coding-standards.md"
echo ""

exit 1
