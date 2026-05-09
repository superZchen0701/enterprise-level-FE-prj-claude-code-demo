# enterprise-level-FE-prj-claude-code-demo

> 企业级前端项目 Claude Code 示范仓库

【持续更新中...】

## 项目简介

本项目是一个企业级前端项目的 Claude Code 示范仓库，展示如何在实际项目中使用 Claude Code 进行高效开发。仓库使用 pnpm monorepo 管理多个子项目，包含：Vue 2 移动端应用示例、Vue 3 移动端应用示例。涵盖项目架构、编码规范、开发流程等最佳实践。

## Claude Code新成员入职清单

### 第1步：环境准备

- [ ] 安装Git、Node.js、pnpm、OpenSpec。
- [ ] 安装Claude Code（参考[Claude Code 官方文档-快速开始-步骤1：安装ClaudeCode](https://code.claude.com/docs/zh-CN/quickstart)）。
- [ ] 使用CC Switch管理多套API模型配置（参考[cc-switch](https://github.com/farion1231/cc-switch)）。

### 第2步：项目配置

- [ ] 克隆项目仓库。
- [ ] 运行 `claude` 命令，打开claude code界面。
- [ ] 运行`!bash install.sh`命令，执行一键安装脚本。

### 第3步：熟悉子项目规范

- [ ] cd 进入相应子项目目录（如`fe-vue2-demo`）。
- [ ] 阅读相应子项目下的`CLAUDE.md`文件。
- [ ] 运行 `/help` 查看可用命令或技能。
- [ ] 尝试执行一次项目源码分析（输入“分析项目源码结构”）。

### 第4步：开发新功能

- [ ] 本地创建feat_xxx_tapdID分支，xx为新功能名称，tapdID为Tapd任务ID。
- [ ] 在子项目目录下运行`pnpm run serve`，启动开发服务。
- [ ] 尝试使用OpenSpec指令进行新功能开发（输入“/opsx:propose 我需要开发新功能：搜索功能，可以在兑换记录页面搜索兑换码。要求如下：1.使用 Vant 的 Search 组件。2.支持实时搜索。”）。
- [ ] 在子项目目录下运行相关pnpm命令（`pnpm run serve`、`pnpm run lint`、`pnpm run build`等），检查新功能是否正常运行。
- [ ] 提交代码至Git仓库：输入“帮我总结变更并提交代码”，按提示操作即可。
- [ ] 创建PR：feat_xxx_tapdID分支至develop分支；创建PR：develop分支至main主分支；验证CI/CD流程。

## 仓库结构

| 目录 | 说明 |
|------|------|
| `fe-vue2-demo/` | 基于 Vue 2 + Vant 2 的移动端 H5 应用 |
| `fe-vue3-demo/` | 基于 Vue 3 + Vant 4 的移动端 H5 应用 |
| `package.json` | 项目根目录下的 package.json 文件，包含所有子项目的执行命令 |
| `.gitignore` | 项目根目录下的 Git 忽略文件，用于忽略不需要提交的文件 |
| `.npmrc` | 项目根目录下的 npm 配置文件，用于设置全局配置 |
| `deploy.sh` | .github/workflows/ci-cd.yml 中的部署脚本，用于CI/CD流水线中部署项目至相应的环境中 |
| `install.sh` | 一键安装脚本，用于安装项目环境需要的依赖 |
| `README.md` | 中文说明文档 |
| `README.en.md` | English Documentation |
| `pnpm-workspace.yaml` | pnpm monorepo 工作区配置 |

## 开发指南

### 环境要求

- Node.js >= 20.x
- pnpm >= 10.x

### 推荐工具

- Claude Code
- pnpm（monorepo 包管理器）

## pnpm Monorepo

本项目使用 pnpm workspace 管理多个子项目，实现统一依赖管理。

### 安装依赖

```bash
# 在根目录下安装所有子项目的依赖
pnpm install
```

### 常用命令

```bash
# 启动 Vue 2 开发服务
pnpm run dev:vue2

# 启动 Vue 3 开发服务
pnpm run dev:vue3

# 代码检查所有项目
pnpm run lint

# 构建所有项目
pnpm run build
```

## 子项目

### fe-vue2-demo

基于 Vue 2 + Vant 2 的移动端应用。

**技术栈：**

| 技术 | 版本 | 说明 |
|------|------|------|
| Vue | 2.6.x | 前端框架 |
| Vue Router | 3.x | 路由管理 |
| Vant | 2.x | 移动端 UI 组件库 |
| Vue CLI | 5.x | 构建工具 |

**快速开始：**

```bash
cd fe-vue2-demo
pnpm run serve
```

**项目文档：**

详见：[fe-vue2-demo/README.md](fe-vue2-demo/README.md)

**Claude Code 配置：**

详见：[fe-vue2-demo/CLAUDE.md](fe-vue2-demo/CLAUDE.md)

**相关资源：**

- [Vue 2 官方文档](https://v2.vuejs.org/)
- [Vant 2 组件库](https://vant-ui.github.io/vant/v2/#/zh-CN/)
- [Vue CLI 文档](https://cli.vuejs.org/)

### fe-vue3-demo

基于 Vue 3 + Vant 4 的移动端应用（Composition API + Vite）。

**技术栈：**

| 技术 | 版本 | 说明 |
|------|------|------|
| Vue | 3.5.x | 前端框架（Composition API） |
| Vue Router | 4.x | 路由管理 |
| Vant | 4.x | 移动端 UI 组件库 |
| Vite | 6.x | 构建工具 |

**快速开始：**

```bash
cd fe-vue3-demo
pnpm run serve
```

**项目文档：**

详见：[fe-vue3-demo/README.md](fe-vue3-demo/README.md)

**Claude Code 配置：**

详见：[fe-vue3-demo/CLAUDE.md](fe-vue3-demo/CLAUDE.md)

**相关资源：**

- [Vue 3 官方文档](https://cn.vuejs.org/)
- [Vant 4 组件库](https://vant-ui.github.io/vant/#/zh-CN)
- [Vite 文档](https://cn.vitejs.dev/)
