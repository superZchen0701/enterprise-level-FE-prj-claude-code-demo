#!/bin/bash
# 编辑文件后自动运行 lint
# 根据编辑文件所属子项目，执行对应的 lint 检查

FILE_PATH="${TOOL_INPUT_PATH:-}"

# 如果环境变量为空，尝试从 stdin 读取
if [ -z "$FILE_PATH" ]; then
  INPUT=$(cat 2>/dev/null || echo "")
  FILE_PATH=$(echo "$INPUT" | grep -o '"file_path"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed 's/.*"file_path"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/')
fi

[ -z "$FILE_PATH" ] && exit 0

PROJECT=""
case "$FILE_PATH" in
  fe-vue2-demo/*) PROJECT="fe-vue2-demo" ;;
  fe-vue3-demo/*) PROJECT="fe-vue3-demo" ;;
  *) exit 0 ;;
esac

echo "=== 自动 lint 检查: $PROJECT ==="
pnpm -C "$PROJECT" run lint 2>&1
