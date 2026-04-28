#!/bin/bash
# 安装 Git Hooks 脚本
# 将项目配置的 hooks 安装到 .git/hooks 目录

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
# .claude 的父目录是项目根目录
REPO_ROOT="$(dirname "$PROJECT_ROOT")"

# 查找 .git 目录
# 优先查找项目根目录下的 .git，如果不存在则向上查找
if [ -d "$REPO_ROOT/.git" ]; then
  GIT_DIR="$REPO_ROOT/.git"
else
  # 向上查找（支持 monorepo 场景）
  find_git_dir() {
    local dir="$1"
    while [ "$dir" != "/" ]; do
      if [ -d "$dir/.git" ]; then
        echo "$dir/.git"
        return 0
      fi
      dir="$(dirname "$dir")"
    done
    return 1
  }
  GIT_DIR=$(find_git_dir "$REPO_ROOT")
fi

# 验证：确保找到了有效的 .git 目录
if [ -z "$GIT_DIR" ]; then
  echo "错误：未找到 .git 目录"
  echo "请确认当前目录在 git 仓库中"
  exit 1
fi

# 安全加固：验证 REPO_ROOT 是否在预期的仓库范围内
# 检查 .git 目录是否有效（包含 HEAD 文件）
if [ ! -f "$GIT_DIR/HEAD" ]; then
  echo "错误：无效的 git 仓库：$GIT_DIR"
  echo "HEAD 文件不存在，可能不是有效的 git 仓库"
  exit 1
fi

GIT_HOOKS_DIR="$GIT_DIR/hooks"

echo "=== 安装 Git Hooks ==="
echo "Git 目录：$GIT_DIR"
echo "Hooks 目录：$GIT_HOOKS_DIR"
echo ""

# 复制 hook 文件
echo "复制 pre-commit hook..."
cp "$SCRIPT_DIR/pre-commit.sh" "$GIT_HOOKS_DIR/pre-commit"
chmod +x "$GIT_HOOKS_DIR/pre-commit"

echo "复制 commit-msg hook..."
cp "$SCRIPT_DIR/git-commit-msg.sh" "$GIT_HOOKS_DIR/commit-msg"
chmod +x "$GIT_HOOKS_DIR/commit-msg"

echo ""
echo "=== 安装完成 ==="
echo "已安装的 hooks:"
echo "  - pre-commit (执行 npm run lint -- --fix)"
echo "  - commit-msg (验证 commit message 格式)"
echo ""
echo "测试方法:"
echo "  git commit -m \"feat(123): 测试提交\""
