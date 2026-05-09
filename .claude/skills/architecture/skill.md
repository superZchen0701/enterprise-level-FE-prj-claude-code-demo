# architecture 技能

**描述**：帮助用户进行架构设计，读取项目架构文档并提供架构设计建议。

**适用范围**：本仓库为 monorepo，需考虑 `fe-vue2-demo/` 和 `fe-vue3-demo/` 两个子项目的架构。

**触发机制**：
1. **Hook 自动触发**：当用户输入包含关键词时，系统会输出 `<system-reminder>` 包含 `Skill required: architecture`
2. **必须响应**：看到此提示后，必须立即调用 Skill 工具执行本技能，不要跳过此步骤
3. **手动触发**：用户可输入 `/architecture` 直接调用

---

## 前置条件

- 用户需要进行架构设计相关的工作
- 需要理解或设计项目架构

---

## 执行步骤

### 1. 读取架构设计文档

读取**所有子项目**的架构设计文档：
- `fe-vue2-demo/docs/ai-context/architecture.md`
- `fe-vue3-demo/docs/ai-context/architecture.md`

### 2. 读取相关文档

根据需要，可能还需要读取：
- `fe-vue2-demo/docs/ai-context/project-structure.md`（Vue2 项目结构）
- `fe-vue3-demo/docs/ai-context/project-structure.md`（Vue3 项目结构）
- `fe-vue2-demo/docs/ai-context/coding-standards.md`（Vue2 编码规范）
- `fe-vue3-demo/docs/ai-context/coding-standards.md`（Vue3 编码规范）

### 3. 分析当前架构

基于文档和用户需求，分析：
- 组件分层结构
- 数据流向
- 设计原则
- 可扩展性考虑

### 4. 提供架构建议

根据分析结果，提供：
- 架构设计建议
- 组件划分建议
- 数据流设计
- 设计模式推荐

---

## 输出格式

```markdown
## 架构设计建议

### 当前架构分析
[基于文档的当前架构理解，区分 Vue2 和 Vue3 子项目]

### 建议方案
[具体的架构设计建议]

### 组件关系图
[如需要，提供 ASCII 图表]

### 实现要点
[关键实现细节和注意事项]
```

---

## 注意事项

1. **架构一致性**：建议需与现有架构风格保持一致
2. **可扩展性**：考虑未来功能扩展的可能性
3. **可维护性**：确保设计便于维护和理解
4. **性能考虑**：关注组件渲染性能和数据流效率
5. **子项目差异**：注意 Vue2（Options API 兼容）和 Vue3（Composition API + TS）的技术差异

---

## 相关文档

- [架构设计 - Vue2](fe-vue2-demo/docs/ai-context/architecture.md)
- [架构设计 - Vue3](fe-vue3-demo/docs/ai-context/architecture.md)
- [项目结构 - Vue2](fe-vue2-demo/docs/ai-context/project-structure.md)
- [项目结构 - Vue3](fe-vue3-demo/docs/ai-context/project-structure.md)
- [编码规范 - Vue2](fe-vue2-demo/docs/ai-context/coding-standards.md)
- [编码规范 - Vue3](fe-vue3-demo/docs/ai-context/coding-standards.md)
