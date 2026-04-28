# enterprise-level-FE-prj-claude-code-demo

> 企业级前端项目 Claude Code 示范仓库

【持续更新中...】

## 项目简介

本项目是一个企业级前端项目的 Claude Code 示范仓库，展示如何在实际项目中使用 Claude Code 进行高效开发。仓库包含一个完整的 Vue 2 移动端应用示例，涵盖项目架构、编码规范、开发流程等最佳实践。

## 仓库结构

| 目录 | 说明 |
|------|------|
| `fe-vue2-demo/` | 基于 Vue 2 + Vant 的移动端 H5 应用 |
| `README.md` | 中文说明文档 |
| `README.en.md` | English Documentation |

## 开发指南

### 环境要求

- Node.js >= 20.19.0
- npm >= 10.1.0

### 推荐工具

- Claude Code

## Claude Code新成员入职清单

### 第1步：环境准备

- [ ] 安装Git、Node.js、npm、OpenSpec。
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

- [ ] 本地运行`npm install`安装依赖，确保项目依赖正常；运行`npm run serve`启动开发服务。
- [ ] 尝试使用OpenSpec指令进行新功能开发（输入“/opsx:propose 我需要开发新功能：搜索功能，可以在兑换记录页面搜索兑换码。要求如下：1.使用 Vant 的 Search 组件。2.支持实时搜索。”）。
- [ ] 本地运行相关npm命令（如`npm run lint`、`npm run serve`、`npm run build`等），检查新功能是否正常运行。
- [ ] 提交一个测试PR验证CI流程。

## 子项目

### fe-vue2-demo

基于 Vue 2 + Vant 的移动端应用。

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

# 安装依赖
npm install

# 开发服务
npm run serve

# 代码检查
npm run lint

# 生产构建
npm run build
```

**项目文档：**

详见：[fe-vue2-demo/README.md](fe-vue2-demo/README.md)

**Claude Code 配置：**

详见：[fe-vue2-demo/CLAUDE.md](fe-vue2-demo/CLAUDE.md)

**相关资源：**

- [Vue 2 官方文档](https://v2.vuejs.org/)
- [Vant 2 组件库](https://vant-contrib.gitee.io/vant/v2/)
- [Vue CLI 文档](https://cli.vuejs.org/)
