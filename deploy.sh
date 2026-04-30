#!/bin/bash
# TODO 待验证 - 部署脚本模板
# 用法：./deploy.sh <environment> <target_dir>
# 示例：./deploy.sh staging /var/www/staging

set -e

ENVIRONMENT=$1
TARGET_DIR=$2
DIST_DIR="./dist"

if [ -z "$ENVIRONMENT" ] || [ -z "$TARGET_DIR" ]; then
    echo "用法：$0 <environment> <target_dir>"
    echo "示例：$0 staging /var/www/staging"
    exit 1
fi

echo "======================================"
echo "部署到 $ENVIRONMENT 环境"
echo "======================================"
echo "源目录：$DIST_DIR"
echo "目标目录：$TARGET_DIR"
echo ""

# 检查 dist 目录是否存在
if [ ! -d "$DIST_DIR" ]; then
    echo "错误：dist 目录不存在，请先运行 npm run build"
    exit 1
fi

# 检查 dist 目录是否为空
if [ -z "$(ls -A "$DIST_DIR" 2>/dev/null)" ]; then
    echo "错误：dist 目录为空，请先运行 npm run build"
    exit 1
fi

# 同步文件（使用 rsync）
echo "正在同步文件..."
rsync -avz --delete --progress "$DIST_DIR/" "$TARGET_DIR/"

echo ""
echo "✅ 部署完成！"
echo "环境：$ENVIRONMENT"
echo "时间：$(date -u)"
