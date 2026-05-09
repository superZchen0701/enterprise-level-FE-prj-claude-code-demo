# fe-vue3-demo

> 基于 Vue 3 + Vant 4 的移动端 H5 应用系统

## 项目简介

一个基于 Vue 3 + Vant 4 的移动端应用，包含兑换记录追踪等业务模块。采用 Composition API + Vite 构建，支持 Mock/真实接口切换，便于开发和联调。

## 技术栈

| 技术 | 版本 | 说明 |
|------|------|------|
| Vue | 3.5.x | 前端框架（Composition API） |
| Vue Router | 4.x | 路由管理 |
| Vant | 4.x | 移动端 UI 组件库 |
| Vite | 6.x | 构建工具 |
| ESLint | 8.x | 代码检查 |

## 快速开始

### 环境要求

- Node.js >= 20.x
- pnpm >= 10.x

### 安装与运行

```bash
# 在根目录安装所有依赖
pnpm install

# 进入子项目
cd fe-vue3-demo

# 开发服务（热更新，默认使用 mock 数据）
pnpm run serve

# 生产构建
pnpm run build

# 预览构建结果
pnpm run preview

# 代码检查与修复
pnpm run lint
```

### 环境配置

项目使用环境变量控制配置，关键变量：

| 变量 | 说明 | 默认值 |
|------|------|--------|
| `VITE_USE_MOCK` | 是否使用 mock 数据 | `true`（开发）/`false`（生产） |
| `VITE_API_BASE_URL` | 后端 API 基础地址 | `http://localhost:8080` |

配置文件：
- `.env.development` - 开发环境配置
- `.env.production` - 生产环境配置
- `.env.example` - 配置模板

## 项目结构

```
fe-vue3-demo/
├── index.html                   # HTML 入口（Vite 默认）
├── public/                      # 静态资源（直接复制到输出目录）
│   └── favicon.ico              # 网站图标
├── src/                         # 源代码目录
│   ├── main.js                  # 应用入口，全局注册组件
│   ├── App.vue                  # 根组件
│   ├── router/index.js          # 路由配置
│   ├── views/                   # 页面级组件（业务逻辑）
│   ├── components/              # 公共组件（可复用 UI）
│   ├── api/                     # API 接口封装
│   ├── utils/                   # 工具函数
│   ├── mock/                    # Mock 数据（开发环境模拟）
│   └── assets/                  # 静态资源
├── openspec/                    # OpenSpec 需求管理目录
│   ├── changes/                 # 变更目录
│   │   └── archive/             # 已归档变更
│   ├── specs/                   # 主规范库
│   ├── config.yaml              # OpenSpec 配置
│   └── README.md                # OpenSpec 使用指南
├── .claude/                     # Claude Code 配置
├── docs/                        # 项目文档
│   └── ai-context/              # AI 上下文文档
├── .env.development             # 开发环境变量
├── .env.production              # 生产环境变量
├── package.json                 # 项目依赖配置
├── vite.config.js               # Vite 构建配置
├── jsconfig.json                # JavaScript 项目配置（@/ 别名）
└── CLAUDE.md                    # Claude Code AI 行为规范
```

## 目录职责

| 目录 | 职责 |
|------|------|
| `src/views/` | 页面级组件，包含业务逻辑和页面布局，文件命名 `PascalCase.vue` |
| `src/components/` | 公共组件，可复用的 UI 元素 |
| `src/api/` | 接口封装，按业务模块划分（如 exchange.js） |
| `src/utils/` | 工具函数，如 HTTP 请求封装（request.js） |
| `src/mock/` | Mock 数据，用于开发环境模拟接口 |
| `src/router/` | Vue Router 实例及路由规则 |
| `openspec/` | OpenSpec 需求管理，包含变更、规范、配置 |
| `.claude/` | Claude Code AI 助手配置，包含命令、技能、钩子 |

## 核心业务模块

- **兑换记录** - 查看和管理兑换记录列表

## Vue 2 → Vue 3 关键差异

| 概念 | Vue 2 (fe-vue2-demo) | Vue 3 (本项目) |
|------|---------------------|----------------|
| 入口 | `new Vue({...}).$mount('#app')` | `createApp(App).mount('#app')` |
| 路由 | `new VueRouter({routes})` | `createRouter({history, routes})` |
| API 风格 | Options API | `<script setup>` Composition API |
| 响应式 | `data()` | `ref()` / `reactive()` |
| 生命周期 | `created()` | `onMounted()`（setup 即 created） |
| Toast | `this.$toast()` | `showToast()` |
| 路由跳转 | `this.$router.back()` | `useRouter().back()` |
| 环境变量 | `process.env.VUE_APP_*` | `import.meta.env.VITE_*` |
| 构建工具 | Vue CLI (Webpack) | Vite |

## OpenSpec 工作流

本项目使用 OpenSpec 进行需求管理和代码生成。详细使用指南请参考 `openspec/README.md`。

### 常用命令

| 命令 | 说明 |
|------|------|
| `/opsx:explore` | 探索模式，讨论需求细节 |
| `/opsx:propose` | 提案模式，生成完整变更规划 |
| `/opsx:apply` | 应用变更，执行代码生成 |
| `/opsx:verify` | 验证变更，检查实现质量 |
| `/opsx:archive` | 归档变更，整理工作区 |

## 路径别名

`@/` 指向 `src/` 目录：

```javascript
import ExchangeRecord from '@/views/ExchangeRecord.vue'
import { getList } from '@/api/exchange'
```

## 规范

详见 [CLAUDE.md](CLAUDE.md)
