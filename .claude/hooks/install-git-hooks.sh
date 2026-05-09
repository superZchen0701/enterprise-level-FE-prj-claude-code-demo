#!/bin/bash
# 安装 Git Hooks 脚本
# 将 .claude/hooks 中的 hook 脚本安装到 .git/hooks 目录

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# SCRIPT_DIR = <repo-root>/.claude/hooks

REPO_ROOT="$(dirname "$(dirname "$SCRIPT_DIR")")"

# 查找 .git 目录
if [ -d "$REPO_ROOT/.git" ]; then
  GIT_DIR="$REPO_ROOT/.git"
else
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

if [ -z "$GIT_DIR" ]; then
  echo "错误：未找到 .git 目录"
  echo "请确认当前目录在 git 仓库中"
  exit 1
fi

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

echo "复制 pre-commit hook..."
cp "$SCRIPT_DIR/pre-commit.sh" "$GIT_HOOKS_DIR/pre-commit"
chmod +x "$GIT_HOOKS_DIR/pre-commit"

echo "复制 commit-msg hook..."
cp "$SCRIPT_DIR/git-commit-msg.sh" "$GIT_HOOKS_DIR/commit-msg"
chmod +x "$GIT_HOOKS_DIR/commit-msg"

echo ""
echo "=== 安装完成 ==="
echo "已安装的 hooks:"
echo "  - pre-commit（自动检测子项目并执行 lint）"
echo "  - commit-msg（验证 commit message 格式）"
echo ""
echo "测试方法:"
echo "  git commit -m \"feat(123): 测试提交\""
