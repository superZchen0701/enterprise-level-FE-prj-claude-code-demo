#!/bin/bash
# install.sh - 团队 Claude 配置一键安装脚本
# 作者：chaozhi
# 版本：1.1

set -e

# ==================== 常量定义 ====================
# 子项目列表（后续可扩展）
declare -a SUB_PROJECTS=(
    "fe-vue2-demo"
    # "be-koa3-bff-demo"  # 示例：未来可能的 Koa 3 BFF 项目
)

# ==================== 颜色定义 ====================
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# ==================== 日志函数 ====================
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

# ==================== 横幅 ====================
show_banner() {
    echo -e "${BLUE}"
    echo "================================================"
    echo "  团队 Claude 配置一键安装脚本 v1.0"
    echo "  作者：chaozhi"
    echo "================================================"
    echo -e "${NC}"
}

# ==================== 检测操作系统 ====================
detect_os() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        OS="linux"
        PLATFORM="Linux"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macos"
        PLATFORM="macOS"
    elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
        OS="windows"
        PLATFORM="Windows (Git Bash)"
    else
        log_error "不支持的操作系统：$OSTYPE"
        exit 1
    fi
    log_info "检测到操作系统：$PLATFORM"
}

# ==================== 检查依赖 ====================
check_dependencies() {
    log_info "检查必要依赖..."

    # 1. 检查 Git
    if ! command -v git &> /dev/null; then
        log_error "未安装 Git，请先安装 Git"
        log_info "下载地址：https://git-scm.com/downloads"
        exit 1
    fi
    log_success "Git 已安装：$(git --version)"

    # 2. 检查 Node.js 是否安装
    if ! command -v node &> /dev/null; then
        log_error "未安装 Node.js，请先安装 Node.js"
        log_info "下载地址：https://nodejs.org/"
        exit 1
    fi
    # Node.js 版本检查 >= 20.xx.xx
    NODE_VERSION=$(node --version | sed 's/v//' | cut -d. -f1)
    if [ "$NODE_VERSION" -lt 20 ]; then
        log_error "Node.js 版本过低 (当前：$(node --version))，要求 >= 20.19.0"
        exit 1
    fi
    log_success "Node.js 已安装：$(node --version)"

    # 3. 检查 npm 是否安装
    if ! command -v npm &> /dev/null; then
        log_error "未安装 npm"
        exit 1
    fi
    # npm 版本检查 >= 10.xx.xx
    NPM_VERSION=$(npm --version | cut -d. -f1)
    if [ "$NPM_VERSION" -lt 10 ]; then
        log_error "npm 版本过低 (当前：$(npm --version))，要求 >= 10.1.0"
        exit 1
    fi
    log_success "npm 已安装：$(npm --version)"

    # 4. 检查是否全局安装了 OpenSpec
    log_info "检查 OpenSpec 安装状态..."
    if command -v openspec &> /dev/null; then
        log_success "OpenSpec 已安装"
    else
        log_error "OpenSpec 未全局安装"
        log_info "安装命令：npm install -g @fission-ai/openspec@1.2.0"
        log_info "参考文档：https://github.com/Fission-AI/OpenSpec/blob/main/docs/installation.md"
        exit 1
    fi
}

# ==================== 安装 Git Hooks ====================
install_git_hooks() {
    log_info "安装 Git Hooks..."

    # 查找 Git Hooks 安装脚本
    local hooks_script=""

    # 查找当前目录下的 Git Hooks 安装脚本
    if [ -f ".claude/hooks/install-git-hooks.sh" ]; then
        hooks_script=".claude/hooks/install-git-hooks.sh"
    fi

    # 查找子项目中的 Git Hooks 安装脚本
    for project in "${SUB_PROJECTS[@]}"; do
        if [ -f "$project/.claude/hooks/install-git-hooks.sh" ]; then
            hooks_script="$project/.claude/hooks/install-git-hooks.sh"
            break
        fi
    done

    if [ -n "$hooks_script" ]; then
        # 执行安装脚本
        if bash "$hooks_script"; then
            log_success "Git Hooks 安装成功"
        else
            log_error "Git Hooks 安装失败"
            return 1
        fi
    else
        log_warn "未找到 Git Hooks 安装脚本，跳过安装"
    fi
}

# ==================== 配置 MCP ====================
# MCP 配置说明：
# - .mcp.json 用于配置 MCP 服务器，让 Claude Code 可以调用外部工具/API
# - 如果项目需要特定的 MCP 服务（如数据库、API 调试等），在此处进行配置
# - 检查根目录和所有子项目的 .mcp.json 配置
configure_mcp() {
    log_info "检查 MCP 配置..."

    local mcp_found=0
    local mcp_invalid=0

    # 验证 JSON 格式的辅助函数（使用 Node.js）
    # 修复：使用 process.argv 传递文件路径，避免命令注入
    validate_json() {
        local file="$1"
        node -e "JSON.parse(require('fs').readFileSync(process.argv[1], 'utf8'))" -- "$file" 2>/dev/null
        return $?
    }

    # 检查根目录的 .mcp.json
    if [ -f ".mcp.json" ]; then
        log_info "发现根目录 MCP 配置文件"
        if validate_json ".mcp.json"; then
            log_success "  [x] .mcp.json 格式有效"
        else
            log_warn "  [!] .mcp.json 格式可能无效"
            mcp_invalid=1
        fi
        mcp_found=1
    fi

    # 检查各子项目的 .mcp.json
    for project in "${SUB_PROJECTS[@]}"; do
        if [ -f "$project/.mcp.json" ]; then
            log_info "发现子项目 MCP 配置文件：$project/.mcp.json"
            if validate_json "$project/.mcp.json"; then
                log_success "  [x] $project/.mcp.json 格式有效"
            else
                log_warn "  [!] $project/.mcp.json 格式可能无效"
                mcp_invalid=1
            fi
            mcp_found=1
        fi
    done

    # 汇总报告
    if [ $mcp_found -eq 0 ]; then
        log_info "未发现 .mcp.json 配置文件（可选配置，非必需）"
        log_info "如需配置 MCP 服务器，可在根目录或子项目目录创建 .mcp.json"
    elif [ $mcp_invalid -eq 1 ]; then
        log_warn "部分 MCP 配置文件格式可能无效，请检查"
    else
        log_success "所有 MCP 配置文件检查通过"
    fi
}

# ==================== 显示使用说明 ====================
show_usage() {
    echo -e "${BLUE}"
    echo "================================================"
    echo "  安装完成！"
    echo "================================================"
    echo ""
    echo "已完成的配置:"
    echo "  [x] 依赖检查"
    echo "  [x] Git Hooks 安装"
    echo "  [x] MCP 配置检查"
    echo ""
    echo "下一步操作:"
    echo "  1. 进入项目目录：cd fe-vue2-demo"
    echo "  2. 运行 Claude Code: claude"
    echo "  3. 参考[fe-vue2-demo/README.md子项目说明文档](fe-vue2-demo/README.md)开始开发"
    echo ""
    echo "更多信息请查看："
    echo "  - README.md - 项目说明文档"
    echo "  - README.en.md - 项目说明文档（英文）"
    echo "================================================"
    echo -e "${NC}"
}

# ==================== 主函数 ====================
main() {
    show_banner

    # 检测操作系统
    detect_os

    # 检查依赖
    check_dependencies

    # 安装 Git Hooks
    install_git_hooks

    # # 配置 MCP（可选）
    configure_mcp

    # # 显示使用说明
    show_usage

    log_success "安装完成！"
}

main
