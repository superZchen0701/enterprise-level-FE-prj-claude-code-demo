#!/bin/bash
# 保护关键文件不被意外修改
# 阻止对 lock 文件和 CI 配置的编辑操作

FILE_PATH="${TOOL_INPUT_PATH:-}"

# 如果环境变量为空，尝试从 stdin 读取
if [ -z "$FILE_PATH" ]; then
  INPUT=$(cat 2>/dev/null || echo "")
  FILE_PATH=$(echo "$INPUT" | grep -o '"file_path"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed 's/.*"file_path"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/')
fi

[ -z "$FILE_PATH" ] && exit 0

# 规范化路径：将 Windows 路径转换为 Unix 风格以便匹配
NORMALIZED_PATH=$(echo "$FILE_PATH" | sed 's/\\/\//g' | sed 's|//|/|g' | sed 's/.*\.github\/workflows\//.github\/workflows\//')

case "$NORMALIZED_PATH" in
  *pnpm-lock.yaml)
    echo '{"continue":false,"stopReason":"不允许直接修改 pnpm-lock.yaml，请通过 pnpm install/add/remove 更新依赖","systemMessage":"BLOCKED: pnpm-lock.yaml 受保护"}'
    exit 1
    ;;
  *.github/workflows/ci-cd.yml)
    echo '{"continue":false,"stopReason":"CI/CD 配置文件受保护，请先在 feature 分支修改并通过测试","systemMessage":"BLOCKED: .github/workflows/ci-cd.yml 受保护"}'
    exit 1
    ;;
esac

exit 0
