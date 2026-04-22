# fe-vue2-demo

> 基于 Vue 2 + Vant 的移动端 H5 应用系统

【持续更新中...】

## 项目简介

一个基于 Vue 2 + Vant 的移动端应用，包含兑换记录追踪等业务模块。采用经典的前后端分离架构，支持 Mock/真实接口切换，便于开发和联调。

## 技术栈

| 技术 | 版本 | 说明 |
|------|------|------|
| Vue | 2.6.x | 前端框架 |
| Vue Router | 3.x | 路由管理 |
| Vant | 2.x | 移动端 UI 组件库 |
| Vue CLI | 5.x | 构建工具（Webpack） |
| ESLint | 7.x | 代码检查 |

## 快速开始

### 环境要求

- Node.js >= 14.x
- npm >= 6.x

### 安装与运行

```bash
# 安装依赖
npm install

# 开发服务（热更新，默认使用 mock 数据）
npm run serve

# 生产构建
npm run build

# 代码检查与修复
npm run lint
```

### 环境配置

项目使用环境变量控制配置，关键变量：

| 变量 | 说明 | 默认值 |
|------|------|--------|
| `VUE_APP_USE_MOCK` | 是否使用 mock 数据 | `true`（开发）/`false`（生产） |
| `VUE_APP_API_BASE_URL` | 后端 API 基础地址 | `http://localhost:8080` |

配置文件：
- `.env.development` - 开发环境配置
- `.env.production` - 生产环境配置
- `.env.example` - 配置模板

## 项目结构

```
fe-vue2-demo/
├── public/                      # 静态资源（直接复制到输出目录）
│   ├── index.html               # HTML 入口模板
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
│   ├── commands/                # 自定义命令
│   ├── skills/                  # 自定义技能
│   └── hooks/                   # 自动化钩子
├── docs/                        # 项目文档
│   └── ai-context/              # AI 上下文文档
├── .env.development             # 开发环境变量
├── .env.production              # 生产环境变量
├── package.json                 # 项目依赖配置
├── vue.config.js                # Vue CLI 构建配置
├── babel.config.js              # Babel 配置
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

### 典型开发流程

1. **需求探索** - 使用 `/opsx:explore` 与 AI 讨论需求细节
2. **创建变更** - 使用 `/opsx:propose` 或 `/opsx:new` 创建变更规划
3. **执行开发** - 使用 `/opsx:apply` 根据任务清单生成代码
4. **验证质量** - 使用 `/opsx:verify` 检查实现是否符合规范
5. **归档完成** - 使用 `/opsx:archive` 归档已完成的变更

## 开发指南

### 新增页面组件

1. 在 `src/views/` 创建新组件（PascalCase 命名）
2. 在 `src/router/index.js` 添加路由配置
3. 如需 API 接口，在 `src/api/` 创建对应模块
4. 如需要 mock 数据，在 `src/mock/` 添加模拟数据

### 新增公共组件

1. 在 `src/components/` 创建组件
2. 在 `main.js` 中全局注册或局部引入使用
3. 编写 Props 接口文档（JSDoc）

### 接口联调流程

1. **开发阶段**：使用 mock 数据（`VUE_APP_USE_MOCK=true`）
2. **联调阶段**：切换为真实 API（`VUE_APP_USE_MOCK=false`）
3. 修改 `.env.development` 中的 `VUE_APP_API_BASE_URL`

### API 请求规范

- 基于 `fetch` API 封装，统一在 `utils/request.js` 中
- 后端响应格式：`{ code: 0, data: {}, message: '' }`
- API 模块按业务划分（如 `api/exchange.js`）

## 路径别名

`@/` 指向 `src/` 目录：

```javascript
import ExchangeRecord from '@/views/ExchangeRecord.vue'
import { getList } from '@/api/exchange'
```

## 开发规范

详见 [CLAUDE.md](CLAUDE.md)，核心规范：

- **语言**：所有对话、解释、文档、代码注释**必须全部使用简体中文**
- **Vue 组件**：使用 Options API，禁止 Composition API
- **命名**：
  - 文件名：kebab-case（如 `user-service.js`）
  - 组件名：PascalCase（如 `UserCard.vue`）
  - 函数/变量：camelCase（如 `getUserById`）
  - 常量：UPPER_SNAKE_CASE（如 `MAX_RETRY_COUNT`）
- **Git 分支**：`feature_xxx` / `fix_xxx` / `refactor_xxx`
- **提交格式**：`<type>(<TAPD ID>): <description>`

## 常见问题

### ESLint 报错自动修复
```bash
npm run lint -- --fix
```

### 清除缓存后重启
```bash
# Windows (Git Bash)
rm -rf node_modules/.cache
npm run serve
```

### Vant 组件样式覆盖
使用 `:deep()` 深度选择器：
```scss
:deep(.van-cell__title) {
  color: #333;
}
```

## 相关文档

| 文档 | 路径 | 内容 |
|-----|------|------|
| 项目结构 | `docs/ai-context/project-structure.md` | 目录结构、目录职责、技术栈、路径别名 |
| 编码规范 | `docs/ai-context/coding-standards.md` | 命名约定、Vue 规范、JS 规范、API 约定 |
| 架构设计 | `docs/ai-context/architecture.md` | 整体架构、组件分层、数据流、设计原则 |
| AI 行为规范 | `CLAUDE.md` | Claude Code 开发行为规范与配置 |
