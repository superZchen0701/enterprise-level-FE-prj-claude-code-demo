#!/bin/bash
# Auto lint hook
# 在 Write 或 Edit 操作后自动运行代码格式化

echo "=== 自动格式化代码 ==="

# 检查 node_modules 是否存在
if [ ! -d "node_modules" ]; then
  echo "跳过: node_modules 不存在"
  exit 0
fi

# 运行 ESLint 自动修复
npm run lint -- --fix 2>/dev/null

if [ $? -eq 0 ]; then
  echo "=== 代码格式化完成 ==="
else
  echo "提示: 存在无法自动修复的代码问题"
fi

exit 0
