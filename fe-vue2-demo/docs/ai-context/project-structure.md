# 项目结构说明文档

## 项目概览

一个基于 Vue CLI 构建的 Vue 2 移动端 h5 应用，主要包含兑换记录追踪等业务模块。

## 目录结构

```
项目根目录/
├── public/                      # 静态资源目录（直接复制到输出目录）
│   ├── index.html               # HTML 入口模板
│   └── favicon.ico              # 网站图标
├── src/                         # 源代码目录
│   ├── main.js                  # 入口文件，全局注册组件
│   ├── App.vue                  # 根组件
│   ├── router/                  # 路由配置
│   │   └── index.js             # Vue Router 实例及路由规则
│   ├── views/                   # 页面级组件
│   ├── components/              # 公共组件
│   ├── api/                     # API 接口封装
│   ├── utils/                   # 工具函数
│   ├── mock/                    # Mock 数据（开发环境模拟）
│   └── assets/                  # 静态资源（图片、字体等）
├── docs/                        # 项目文档
│   └── ai-context/              # AI 上下文文档
├── .env.development             # 开发环境变量
├── .env.production              # 生产环境变量
├── package.json                 # 项目依赖配置
├── vue.config.js                # Vue CLI 构建配置
├── babel.config.js              # Babel 配置
├── jsconfig.json                # JavaScript 项目配置（路径别名）
└── CLAUDE.md                    # Claude Code AI 行为规范
```

## 技术栈

| 技术 | 版本 | 用途 |
|------|------|------|
| Vue | 2.6.x | 前端框架 |
| Vue Router | 3.x | 路由管理 |
| Vant | 2.x | 移动端 UI 组件库 |
| Vue CLI | 5.x | 构建工具 |
| ESLint | - | 代码检查 |

## 目录职责

### src/main.js
Vue 应用入口文件，负责：
- 创建 Vue 实例
- 全局注册 Vant 组件（NavBar、Cell、Loading、Toast）
- 挂载路由

### src/router/index.js
路由配置，负责：
- 定义路由规则
- 配置路由守卫（如有）
- 根路径重定向到主页面

### src/views/
页面级组件，包含业务逻辑和页面布局。
- 文件命名：`PascalCase.vue`（如 ExchangeRecord.vue）
- 路由对应的页面组件放在此目录

### src/components/
公共组件，可复用的 UI 组件。
- 文件命名：`PascalCase.vue`
- 无需传递 props 的组件可以直接使用

### src/api/
接口封装，封装与后端交互的接口。
- 按业务模块划分文件（如 exchange.js）
- 统一管理接口路径和请求参数
- 支持 Mock/真实接口切换

### src/utils/
工具函数，提供通用功能。
- HTTP 请求封装（如 request.js）
- 格式化工具
- 通用业务逻辑

### src/mock/
Mock 数据，用于开发环境模拟接口。
- 提供模拟数据和模拟接口函数
- 支持分页、筛选等数据操作

### src/assets/
静态资源，如图片、字体等。
- 构建时会直接复制到输出目录

## 路径别名

项目配置了路径别名 `@/` 指向 `src/` 目录，可在代码中这样使用：

```javascript
import ExchangeRecord from '@/views/ExchangeRecord.vue'
import { getList } from '@/api/exchange'
```

## 相关文档

- 编码规范：`@docs/ai-context/coding-standards.md`
- 架构设计：`@docs/ai-context/architecture.md`
