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

# 生产构建
npm run build
```

详细文档请查看：[fe-vue2-demo/README.md](fe-vue2-demo/README.md)

## Claude Code 配置

### 语言规则

本仓库所有对话、解释、文档、代码注释**必须全部使用简体中文**。

### 核心规范

- **Vue 组件**：使用 Options API，禁止 Composition API
- **命名规范**：
  - 文件名：kebab-case（如 `user-service.js`）
  - 组件名：PascalCase（如 `UserCard.vue`）
  - 函数/变量：camelCase（如 `getUserById`）
- **Git 提交**：`<type>(<TAPD ID>): <description>`

详细规范请查看：[fe-vue2-demo/CLAUDE.md](fe-vue2-demo/CLAUDE.md)

## 项目文档

每个子项目都包含完整的文档体系：

| 文档 | 说明 |
|------|------|
| README.md | 项目说明与快速开始 |
| CLAUDE.md | Claude Code 开发行为规范 |
| docs/ai-context/ | AI 上下文文档（项目结构、编码规范、架构设计） |

## 开发指南

### 环境要求

- Node.js >= 14.x
- npm >= 6.x

### 推荐工具

- VS Code + Volar 扩展
- 终端：Git Bash（Windows）或默认终端（macOS/Linux）

## 相关资源

- [Vue 2 官方文档](https://v2.vuejs.org/)
- [Vant 2 组件库](https://vant-contrib.gitee.io/vant/v2/)
- [Vue CLI 文档](https://cli.vuejs.org/)
