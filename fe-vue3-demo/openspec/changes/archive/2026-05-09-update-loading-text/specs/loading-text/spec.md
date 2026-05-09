## MODIFIED Requirements

### Requirement: Loading text display

当页面正在加载兑换记录数据时，系统 MUST 展示"列表加载中..."的加载提示文案。

#### Scenario: 数据加载中
- **WHEN** 用户进入兑换记录页面且数据正在请求中
- **THEN** 页面展示"列表加载中..."的加载提示

#### Scenario: 数据加载完成
- **WHEN** 数据请求完成且 records 已更新
- **THEN** 加载提示消失，展示数据列表
