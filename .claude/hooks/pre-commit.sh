#!/bin/bash
# Git pre-commit hook
# 在 git commit 前执行代码检查，先尝试自动修复
# 规范来源：@docs/ai-context/coding-standards.md

echo "=== 执行提交前检查 ==="

REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null)"
if [ -z "$REPO_ROOT" ]; then
  echo "错误：无法定位 git 仓库根目录"
  exit 1
fi

# 获取暂存区文件列表
STAGED_FILES=$(git diff --cached --name-only 2>/dev/null)

# 子项目列表
SUB_PROJECTS=("fe-vue2-demo" "fe-vue3-demo")

# 找出有暂存变更的子项目
declare -a CHANGED_PROJECTS=()
for project in "${SUB_PROJECTS[@]}"; do
  if echo "$STAGED_FILES" | grep -q "^$project/"; then
    CHANGED_PROJECTS+=("$project")
  fi
done

# 如果没有任何子项目有变更，扫描所有子项目（安全策略）
if [ ${#CHANGED_PROJECTS[@]} -eq 0 ]; then
  CHANGED_PROJECTS=("${SUB_PROJECTS[@]}")
fi

# 判断是否为 CI 环境（如 GitHub Actions 调用）
if [ "${CI:-false}" = "true" ]; then
  CHANGED_PROJECTS=("${SUB_PROJECTS[@]}")
fi

OVERALL_EXIT=0

for project in "${CHANGED_PROJECTS[@]}"; do
  PROJECT_DIR="$REPO_ROOT/$project"

  if [ ! -d "$PROJECT_DIR" ]; then
    continue
  fi

  echo ""
  echo "----------------------------------------"
  echo "检查项目：$project"
  echo "----------------------------------------"

  # 检查 node_modules 是否存在
  if [ ! -d "$PROJECT_DIR/node_modules" ]; then
    echo "警告：$project/node_modules 不存在，请先运行 pnpm install"
    continue
  fi

  # 检测包管理器
  if [ -f "$PROJECT_DIR/pnpm-lock.yaml" ]; then
    PKG_MGR="pnpm"
  elif [ -f "$PROJECT_DIR/package-lock.json" ]; then
    PKG_MGR="npm"
  else
    PKG_MGR="pnpm"
  fi

  cd "$PROJECT_DIR"

  # 收集需要检查的文件：优先使用暂存区文件，否则收集所有源码文件
  PROJECT_STAGED=$(git diff --cached --name-only --diff-filter=ACMR --relative 2>/dev/null)
  if [ -n "$PROJECT_STAGED" ]; then
    CHECK_FILES=$(echo "$PROJECT_STAGED" | grep -E '\.(vue|js|ts)$' || true)
  else
    CHECK_FILES=$(find . -type f \( -name "*.vue" -o -name "*.js" -o -name "*.ts" \) -not -path "./node_modules/*" -not -path "./dist/*" 2>/dev/null || true)
  fi

  # 执行 lint 修复
  echo "运行 ESLint 自动修复..."
  if [ "$PKG_MGR" = "pnpm" ]; then
    pnpm run lint 2>&1 || true
  else
    npm run lint -- --fix 2>&1 || true
  fi

  # ESLint 修复的是工作目录文件，需要将其加入暂存区
  if [ -n "$CHECK_FILES" ]; then
    while IFS= read -r f; do
      [ -n "$f" ] && [ -f "$f" ] && git add "$f" 2>/dev/null || true
    done < <(echo "$CHECK_FILES")
  fi

  # 修复后再次检查
  echo ""
  echo "运行 ESLint 检查..."
  if [ "$PKG_MGR" = "pnpm" ]; then
    LINT_OUTPUT=$(pnpm run lint 2>&1)
  else
    LINT_OUTPUT=$(npm run lint 2>&1)
  fi
  LINT_EXIT_CODE=$?

  echo "$LINT_OUTPUT"

  if [ $LINT_EXIT_CODE -ne 0 ]; then
    echo ""
    echo "错误：$project 代码检查未通过，存在无法自动修复的问题"
    OVERALL_EXIT=1
  elif echo "$LINT_OUTPUT" | grep -q "warning"; then
    echo ""
    echo "警告：$project 存在 ESLint warning，建议修复"
  else
    echo ""
    echo "$project 检查通过"
  fi

  cd "$REPO_ROOT"
done

echo ""
if [ $OVERALL_EXIT -ne 0 ]; then
  echo "=== 提交前检查未通过 ==="
  exit 1
else
  echo "=== 提交前检查通过 ==="
  exit 0
fi
