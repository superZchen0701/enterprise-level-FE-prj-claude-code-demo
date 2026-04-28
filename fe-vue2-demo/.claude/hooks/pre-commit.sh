#!/bin/bash
# Git pre-commit hook
# 在 git commit 前执行代码检查，先尝试自动修复
# 规范来源：@docs/ai-context/coding-standards.md

echo "=== 执行提交前检查 ==="

# 获取 git hooks 所在目录
HOOKS_DIR="$(cd "$(dirname "$0")" && pwd)"
# Git 仓库根目录的父目录（仓库根目录）
GIT_REPO_DIR="$(dirname "$(dirname "$HOOKS_DIR")")"

# 查找项目根目录（包含 node_modules 和 docs 目录的地方）
find_project_root() {
  # 检查是否在 monorepo 的子项目中
  # 场景：.git 在父目录，fe-vue2-demo 是子项目
  if [ -d "$GIT_REPO_DIR/fe-vue2-demo/node_modules" ]; then
    echo "$GIT_REPO_DIR/fe-vue2-demo"
    return 0
  fi

  # 检查 git root 是否有 node_modules
  if [ -d "$GIT_REPO_DIR/node_modules" ]; then
    echo "$GIT_REPO_DIR"
    return 0
  fi

  # 默认返回 fe-vue2-demo（monorepo 子项目）
  if [ -d "$GIT_REPO_DIR/fe-vue2-demo" ]; then
    echo "$GIT_REPO_DIR/fe-vue2-demo"
    return 0
  fi

  # 默认返回 git root
  echo "$GIT_REPO_DIR"
}

PROJECT_ROOT=$(find_project_root)
STANDARDS_FILE="$PROJECT_ROOT/docs/ai-context/coding-standards.md"

echo "项目根目录：$PROJECT_ROOT"

# 检查 node_modules 是否存在
if [ ! -d "$PROJECT_ROOT/node_modules" ]; then
  echo "错误：node_modules 不存在，请先运行 npm install"
  exit 1
fi

# 从 coding-standards.md 读取 lint 命令
# 匹配：- 使用 `npm run lint` 进行检查和修复
if [ -f "$STANDARDS_FILE" ]; then
  LINT_CMD=$(grep -E "使用 \`npm run lint\`" "$STANDARDS_FILE" 2>/dev/null | sed -E 's/.*使用 `([^`]+)`.*/\1/')
  if [ -z "$LINT_CMD" ]; then
    LINT_CMD="npm run lint"
  fi
else
  LINT_CMD="npm run lint"
fi

echo "使用命令：$LINT_CMD"
echo ""

# 切换到项目根目录执行 npm 命令
cd "$PROJECT_ROOT"

# 先尝试自动修复
echo "运行 ESLint 自动修复..."
eval "$LINT_CMD -- --fix"

# 修复后再次检查
echo ""
echo "运行 ESLint 检查..."
LINT_OUTPUT=$(eval "$LINT_CMD" 2>&1)
LINT_EXIT_CODE=$?

echo "$LINT_OUTPUT"

# 检查是否有 error（ESLint 有 error 时返回 1）
if [ $LINT_EXIT_CODE -ne 0 ]; then
  echo ""
  echo "错误：代码检查未通过，存在无法自动修复的问题"
  echo ""

  # 显示 ESLint 规则配置
  if [ -f "$STANDARDS_FILE" ]; then
    echo "ESLint 规则（来自 @docs/ai-context/coding-standards.md）:"
    grep -A2 "### ESLint 规则" "$STANDARDS_FILE" 2>/dev/null | grep -E "^- " | sed 's/^/  /' | sed 's/&lt;/</g; s/&gt;/>/g'
    echo ""
  fi

  exit 1
fi

# 额外检查：如果有 warning，也提示用户（但不阻止提交）
if echo "$LINT_OUTPUT" | grep -q "warning"; then
  echo ""
  echo "警告：存在 ESLint warning，建议修复"
fi

echo ""
echo "=== 提交前检查通过 ==="
exit 0
