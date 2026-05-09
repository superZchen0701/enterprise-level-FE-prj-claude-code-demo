## Context

兑换记录页面 `ExchangeRecord.vue` 当前使用 Vant 的 `<van-loading>` 组件展示加载状态，文案为"加载中..."。该文案较为笼统，用户无法明确知道哪个部分正在加载。

## Goals / Non-Goals

**Goals:**
- 将加载提示文案改为"列表加载中..."，提升语义明确性

**Non-Goals:**
- 不改变加载逻辑、组件结构或样式

## Decisions

- 仅修改模板中 `<van-loading>` 组件的文本内容，不涉及任何其他改动。此为纯文案调整，无技术选型争议。

## Risks / Trade-offs

- 无风险。纯文本变更，不影响功能、性能或兼容性。
