#!/bin/bash
# Git commit-msg hook
# 验证 commit message 是否符合项目规范
# 规范来源：@docs/ai-context/coding-standards.md

COMMIT_MSG_FILE=$1
COMMIT_MSG=$(cat "$COMMIT_MSG_FILE")

echo "=== 验证 Commit Message 格式 ==="

REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null)"
if [ -z "$REPO_ROOT" ]; then
  REPO_ROOT="$(cd "$(dirname "$0")" && pwd)"
fi

# 尝试从子项目目录中读取 type 列表（优先 fe-vue2-demo，其次 fe-vue3-demo）
STANDARDS_FILE=""
# 子项目列表
SUB_PROJECTS=("fe-vue2-demo" "fe-vue3-demo")

for project in "${SUB_PROJECTS[@]}"; do
  if [ -f "$REPO_ROOT/$project/docs/ai-context/coding-standards.md" ]; then
    STANDARDS_FILE="$REPO_ROOT/$project/docs/ai-context/coding-standards.md"
    break
  fi
done

if [ -f "$STANDARDS_FILE" ]; then
  TYPES=$(grep -E "^- \`(\w+)\`:" "$STANDARDS_FILE" 2>/dev/null | sed -E 's/- `(\w+)`: .*/\1/' | tr '\n' '|' | sed 's/|$//')
  FORMAT=$(grep -A1 "### 提交格式" "$STANDARDS_FILE" 2>/dev/null | grep -E "^\`\`\`" -A1 | tail -1 | tr -d '` ')
else
  TYPES="feat|fix|docs|style|refactor|test|chore"
  FORMAT="<type>(<tapdID>): <description>"
fi

if [ -z "$TYPES" ]; then
  TYPES="feat|fix|docs|style|refactor|test|chore"
fi
if [ -z "$FORMAT" ]; then
  FORMAT="<type>(<tapdID>): <description>"
fi

REGEX="^($TYPES)\([0-9]+\): .+"

if echo "$COMMIT_MSG" | grep -qE "^($TYPES)\([0-9]+\): .+"; then
  echo "✓ 格式正确：$COMMIT_MSG"
  echo "=== 验证通过 ==="
  exit 0
fi

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
echo "  fix(456): 修复页面加载异常"
echo ""
echo "详见：@docs/ai-context/coding-standards.md"
echo ""

exit 1
