## Why

当前兑换记录页面的加载提示文案为"加载中..."，语义较为笼统。为提升用户体验，需要将其改为更明确的"列表加载中..."，让用户清楚知道是列表数据正在加载。

## What Changes

- 修改 `ExchangeRecord.vue` 中的 Vant Loading 组件文案：`加载中...` → `列表加载中...`

## Capabilities

### New Capabilities
<!-- No new capabilities introduced -->

### Modified Capabilities
<!-- No existing capabilities requirements changing -->

## Impact

- 仅影响 `src/views/ExchangeRecord.vue` 中的 Loading 组件展示文案
- 无 API、依赖或架构影响
- 纯 UI 文案调整，不影响任何功能逻辑
