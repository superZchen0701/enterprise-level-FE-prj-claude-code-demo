#!/bin/bash
# install.sh - 团队 Claude Code 配置一键安装脚本
# 作者：chaozhi
# 版本：1.0

set -e

# ==================== 常量定义 ====================
# 子项目列表（后续可扩展）
declare -a SUB_PROJECTS=(
    "fe-vue2-demo"
    "fe-vue3-demo"
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
    echo "  团队 Claude Code 配置一键安装脚本 v1.0"
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
    log_info "一、检查必要依赖..."

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
        log_error "Node.js 版本过低 (当前：$(node --version))，要求 >= 20.xx.xx"
        exit 1
    fi
    log_success "Node.js 已安装：$(node --version)"

    # 3. 检查 pnpm 是否安装
    if ! command -v pnpm &> /dev/null; then
        log_error "未安装 pnpm，将使用 npm 安装 pnpm"
        npm install -g pnpm
    fi
    # pnpm 版本检查 >= 10.xx.xx
    PNPM_VERSION=$(pnpm --version | cut -d. -f1)
    if [ "$PNPM_VERSION" -lt 10 ]; then
        log_error "pnpm 版本过低 (当前：$(pnpm --version))，要求 >= 10.xx.xx"
        log_info "升级命令：npm install -g pnpm@latest"
        exit 1
    fi
    log_success "pnpm 已安装：$(pnpm --version)"

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
    log_info "二、安装 Git Hooks..."

    local hooks_scripts=()

    # 根目录的 Git Hooks 安装脚本（主脚本，包含所有公共 hooks）
    if [ -f ".claude/hooks/install-git-hooks.sh" ]; then
        hooks_scripts+=(".claude/hooks/install-git-hooks.sh")
    fi

    if [ ${#hooks_scripts[@]} -gt 0 ]; then
        local all_success=true
        for hooks_script in "${hooks_scripts[@]}"; do
            log_info "执行：$hooks_script"
            if bash "$hooks_script"; then
                log_success "  $hooks_script 执行成功"
            else
                log_error "  $hooks_script 执行失败"
                all_success=false
            fi
        done

        if $all_success; then
            log_success "Git Hooks 安装成功"
        else
            log_error "部分 Git Hooks 安装失败"
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
# - 仅检查根目录下的 .mcp.json 配置
configure_mcp() {
    log_info "三、检查 MCP 配置..."

    local mcp_found=0
    local mcp_invalid=0

    # 验证 JSON 格式的辅助函数（使用 Node.js）
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

    # 汇总报告
    if [ $mcp_found -eq 0 ]; then
        log_info "未发现 .mcp.json 配置文件（可选配置，非必需）"
        log_info "如需配置 MCP 服务器，可在根目录创建 .mcp.json"
    elif [ $mcp_invalid -eq 1 ]; then
        log_warn "MCP 配置文件格式可能无效，请检查"
    else
        log_success "MCP 配置文件检查通过"
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
    echo "  1. 安装依赖：pnpm install"
    echo "  2. 运行 Claude Code: claude"
    echo "  3. 参考子项目(${SUB_PROJECTS[*]}) README.md 开始开发"
    echo ""
    echo "更多信息请查看："
    echo "  - README.md - 项目说明文档"
    echo "  - README.en.md - 项目说明文档（英文）"
    echo "================================================"
    echo -e "${NC}"
}

# ==================== 主函数 ====================
main() {
    # 显示横幅
    show_banner

    # 检测操作系统
    detect_os

    # 检查依赖
    check_dependencies

    # 安装 Git Hooks
    install_git_hooks

    # 配置 MCP（可选）
    configure_mcp

    # 显示使用说明
    show_usage

    log_success "安装完成！"
}

main
