# 编码规范文档

## 命名约定

### 文件命名
- 组件文件：PascalCase，如 `ExchangeRecord.vue`
- 普通 JS 文件：camelCase，如 `data.js`
- 配置文件：kebab-case，如 `vue.config.js`

### 变量命名
- 变量、函数：camelCase
- 常量：UPPER_SNAKE_CASE
- 组件名：PascalCase

### CSS 类名
- 使用 kebab-case，如 `.record-item`

## Vue 组件规范

### 组件结构
```vue
<template>
  <!-- 模板内容 -->
</template>

<script>
export default {
  name: 'ComponentName',
  components: {},
  props: {},
  data() {
    return {}
  },
  computed: {},
  watch: {},
  created() {},
  mounted() {},
  methods: {}
}
</script>

<style scoped>
/* 样式内容 */
</style>
```

### Props 定义
```javascript
// ✅ 正确：有类型和默认值
props: {
  title: {
    type: String,
    default: ''
  },
  count: {
    type: Number,
    default: 0
  }
}

// ❌ 错误：无类型定义
props: ['title', 'count']
```

### API 使用
- 必须使用 Options API
- 禁止使用 Composition API（setup、ref、reactive 等）

## JavaScript 规范

### ESLint 规则
- `plugin:vue/essential` + `eslint:recommended`
- 使用 `npm run lint` 进行检查和修复

### 注释规范
- 复杂逻辑必须添加中文注释
- 函数注释说明用途、参数和返回值
- 单行注释使用 `//`，多行注释使用 `/* */`

### 导入顺序
```javascript
// 1. Vue 核心
import Vue from 'vue'
import VueRouter from 'vue-router'

// 2. UI 组件
import { NavBar, Cell } from 'vant'

// 3. 本地模块
import { mockData } from '@/mock/data'
```

## API 约定

### 请求封装
基于 fetch API 封装，统一处理请求和响应。

### 响应格式
后端统一响应格式：
```javascript
{
  code: 0,        // 状态码：0 成功，其他失败
  data: {},       // 响应数据
  message: ''     // 提示信息
}
```

### 接口模块划分
按业务模块划分（如 `@/api/exchange.js`、`@/api/user.js`）。

### Mock/真实接口切换
通过环境变量 `VUE_APP_USE_MOCK` 控制。

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

### 响应式单位
使用 `rem` 或 `vw` 进行移动端适配

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
- 功能分支：`feature_xxx_<tapdID>`
- 修复分支：`fix_xxx_<tapdID>`
- 重构分支：`refactor_xxx_<tapdID>`

## 安全规范

- 禁止硬编码 API Key、密码等敏感信息
- 禁止提交 `.env` 文件
- 所有用户输入必须验证

## 相关文档

- 项目结构：`@docs/ai-context/project-structure.md`
- 架构设计：`@docs/ai-context/architecture.md`
