#!/bin/bash
# Pre-commit check hook
# 在 git commit 前执行代码检查和 lint

echo "=== 执行提交前检查 ==="

# 检查 node_modules 是否存在
if [ ! -d "node_modules" ]; then
  echo "错误: node_modules 不存在，请先运行 npm install"
  exit 1
fi

# 运行 ESLint 检查
echo "运行 ESLint 检查..."
npm run lint

if [ $? -ne 0 ]; then
  echo "错误: 代码检查未通过，请修复后再提交"
  exit 1
fi

echo "=== 提交前检查通过 ==="
exit 0
