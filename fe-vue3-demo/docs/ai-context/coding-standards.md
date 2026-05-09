# 编码规范文档

## 命名约定

### 文件命名
- 组件文件：PascalCase，如 `ExchangeRecord.vue`
- 普通 TS 文件：camelCase，如 `exchange.ts`
- 配置文件：kebab-case，如 `vite.config.ts`

### 变量命名
- 变量、函数：camelCase
- 常量：UPPER_SNAKE_CASE
- 组件名：PascalCase

### CSS 类名
- 使用 kebab-case，如 `.record-item`

## Vue 组件规范

### 组件结构（Composition API `<script setup lang="ts">`）
```vue
<template>
  <!-- 模板内容 -->
</template>

<script setup lang="ts">
import { ref, reactive, computed, watch, onMounted } from 'vue'

// Props
interface Props {
  title?: string
  count?: number
}
const props = withDefaults(defineProps<Props>(), {
  title: '',
  count: 0
})

// Emits
const emit = defineEmits<{
  update: [value: string]
  delete: [id: number]
}>()

// 响应式状态
const count = ref<number>(0)

// 计算属性
const doubleCount = computed<number>(() => count.value * 2)

// 生命周期
onMounted(() => {
  // 初始化逻辑
})
</script>

<style scoped>
/* 样式内容 */
</style>
```

### Props 定义
```typescript
// ✅ 正确：使用 TypeScript 泛型 + withDefaults
interface Props {
  title?: string
  count?: number
  disabled?: boolean
}
const props = withDefaults(defineProps<Props>(), {
  title: '',
  count: 0,
  disabled: false
})

// ❌ 错误：使用运行时定义（不符合 TS 项目规约）
const props = defineProps({
  title: {
    type: String,
    default: ''
  }
})
```

### API 使用
- 必须使用 `<script setup lang="ts">` Composition API
- 禁止使用 Options API（data、methods、created 等）
- 响应式数据使用 `ref()` 或 `reactive()`
- 路由使用 `useRouter()` / `useRoute()`
- 命令式 UI（Toast/Dialog）从 vant 直接导入

## TypeScript 规范

### 类型定义
- 公共接口/类型定义在模块文件中，通过 `export type` 导出
- 复杂类型使用 `interface`，简单联合类型使用 `type`
- 避免使用 `any`，优先使用 `unknown` 或具体类型

### 导入类型
```typescript
// 使用 import type 导入仅用于类型检查的内容
import type { ExchangeRecord, PaginationResult } from '@/mock'
import { getExchangeRecords } from '@/api/exchange'
```

### 类型注解
- 函数参数和返回值必须显式声明类型
- `ref` 使用泛型指定类型：`ref<ExchangeRecord[]>([])`
- 异步函数明确声明 `Promise<T>` 返回类型

### 导入顺序
```typescript
// 1. Vue 核心
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'

// 2. 类型导入
import type { ExchangeRecord } from '@/mock'

// 3. UI 组件
import { showToast } from 'vant'

// 4. 本地模块
import { getExchangeRecords } from '@/api/exchange'
```

## API 约定

### 请求封装
基于 fetch API 封装，统一处理请求和响应。

### 响应格式
后端统一响应格式（见 `src/utils/request.ts` 中的 `ApiResponse` 接口）：
```typescript
interface ApiResponse {
  code: number    // 状态码：0 成功，其他失败
  data: unknown   // 响应数据
  message: string // 提示信息
}
```

### Mock/真实接口切换
通过环境变量 `VITE_USE_MOCK` 控制（`import.meta.env.VITE_USE_MOCK`）。

## 样式规范

### 深度选择器
使用 `:deep()` 覆盖 Vant 组件样式：
```scss
:deep(.van-cell__title) {
  color: #333;
}
```

### 页面样式
- 卡片样式：白色背景，圆角，阴影
- 文字颜色：`#333`（主）、`#666`（次）、`#999`（提示）

## Git 提交规范

### 提交格式
```
<type>(<tapdID>): <description>
```

### Type 类型
- `feat`: 新功能
- `fix`: 修复 bug
- `docs`: 文档更新
- `style`: 代码格式
- `refactor`: 重构
- `test`: 测试相关
- `chore`: 构建/工具相关

### 分支命名
- 功能分支：`feat_xxx_<tapdID>`
- 修复分支：`fix_xxx_<tapdID>`

## 安全规范

- 禁止硬编码 API Key、密码等敏感信息
- 禁止提交 `.env` 文件
- 所有用户输入必须验证

## 相关文档

- 项目结构：`@docs/ai-context/project-structure.md`
- 架构设计：`@docs/ai-context/architecture.md`
