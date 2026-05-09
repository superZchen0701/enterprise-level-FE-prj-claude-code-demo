# 架构设计文档

本文档描述项目的整体架构设计，包括组件关系、数据流、设计模式等。

## 整体架构

```
┌─────────────────────────────────────────┐
│                   App.vue               │
│              (根组件/外壳)               │
│                                         │
│              ┌────────────┐             │
│              │router-view │             │
│              └────────────┘             │
└─────────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────┐
│           ExchangeRecord.vue            │
│              (页面级组件)                │
│                                         │
│  ┌──────┐   ┌────────────────┐         │
│  │NavBar│   │  Record List   │         │
│  └──────┘   └────────────────┘         │
└─────────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────┐
│              api/exchange.ts            │
│              (API 接口层)                │
└─────────────────────────────────────────┘
                     │
              ┌──────┴──────┐
              ▼             ▼
       ┌──────────┐   ┌──────────┐
       │  mock/   │   │  真实API  │
       └──────────┘   └──────────┘
              │             │
              ▼             ▼
       ┌──────────┐   ┌──────────┐
       │request.ts│   │  fetch   │
       └──────────┘   └──────────┘
```

## 组件分层

### 页面级组件 (src/views/)
- 负责页面整体布局
- 处理业务逻辑和数据获取
- 使用 `<script setup lang="ts">` Composition API
- 通过 `ref<T>` / `reactive` 管理状态，显式声明类型
- 类型定义复用 `src/mock/` 中的接口

### 公共组件 (src/components/)
- 可复用的 UI 元素
- 通过 `defineProps` 接收 props
- 通过 `defineEmits` 向父组件发送事件

### 第三方组件 (Vant 4)
- 使用 Vant 4 移动端组件库
- 通过 `:deep()` 覆盖组件样式
- 命令式 API 从 vant 直接导入（如 `showToast`）

## 数据流

```
用户操作 → 组件函数 → API 请求 → 更新 ref → 视图自动更新
```

### 状态管理策略
- **当前实现**：组件内部状态使用 `ref<T>()` / `reactive()` 管理
- **组件通信**：`defineProps<T>()` + `withDefaults` 向下传递，`defineEmits<T>()` 向上传递
- **扩展建议**：当组件层级变深时，考虑引入 Pinia

## 设计原则

### 单一职责
- 每个组件专注于单一功能
- API 模块按业务划分

### 可测试性
- 工具函数独立于组件，便于单元测试
- API 接口封装便于 mock 和替换

### 可扩展性
- Mock 数据与真实接口结构一致，切换成本低
- 组件支持 props 配置，易于复用

## 开发流程

### 环境配置
| 环境 | 变量 | 说明 |
|------|------|------|
| 开发环境 | `.env.development` | `VITE_USE_MOCK=true` |
| 生产环境 | `.env.production` | `VITE_USE_MOCK=false` |

### 构建配置
- `vite.config.ts`：Vite 插件、路径别名、开发服务器配置
- `tsconfig.json`：TypeScript 编译配置（strict 模式）
- Vite 内置 esbuild，无需 babel 配置

### 类型检查
- `pnpm run typecheck`：使用 vue-tsc 进行 TypeScript 类型检查
- `pnpm run lint`：ESLint 检查并自动修复（含 @typescript-eslint）

## Vue 2 → Vue 3 架构差异

| 方面 | Vue 2 (fe-vue2-demo) | Vue 3 (本项目) |
|------|---------------------|----------------|
| 语言 | JavaScript | TypeScript |
| 应用创建 | `new Vue({...}).$mount('#app')` | `createApp(App).mount('#app')` |
| 路由 | `new VueRouter({routes})` | `createRouter({history, routes})` |
| 状态 | `data()` 返回对象 | `ref()` / `reactive()` |
| 生命周期 | `created()`, `mounted()` | `onMounted()` （setup 即 created） |
| 构建 | Webpack (Vue CLI) | Vite (esbuild + rollup) |
| API 风格 | Options API | `<script setup>` Composition API |
| Props 定义 | 运行时 `props: { type: ... }` | TypeScript `defineProps<T>()` + `withDefaults` |
| Emits 定义 | 运行时 `defineEmits(['event'])` | TypeScript `defineEmits<{ event: [...] }>()` |

## 相关文档

- 项目结构：`@docs/ai-context/project-structure.md`
- 编码规范：`@docs/ai-context/coding-standards.md`
