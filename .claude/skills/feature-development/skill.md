# feature-development 技能

**描述**：帮助用户开发新功能，读取架构设计文档和编码规范，提供开发指导。

**适用范围**：本仓库为 monorepo，新功能可能涉及 `fe-vue2-demo/` 或 `fe-vue3-demo/` 或两者。

**触发机制**：
1. **Hook 自动触发**：当用户输入包含关键词时，系统会输出 `<system-reminder>` 包含 `Skill required: feature-development`
2. **必须响应**：看到此提示后，必须立即调用 Skill 工具执行本技能，不要跳过此步骤
3. **手动触发**：用户可输入 `/feature-development` 直接调用

---

## 前置条件

- 用户需要开发新功能
- 需要了解项目的架构设计和编码规范

---

## 执行步骤

### 1. 读取架构设计文档

读取**所有子项目**的核心文档：

- `fe-vue2-demo/docs/ai-context/architecture.md`（Vue2 架构设计）
- `fe-vue3-demo/docs/ai-context/architecture.md`（Vue3 架构设计）
- `fe-vue2-demo/docs/ai-context/coding-standards.md`（Vue2 编码规范）
- `fe-vue3-demo/docs/ai-context/coding-standards.md`（Vue3 编码规范）
- `fe-vue2-demo/docs/ai-context/project-structure.md`（Vue2 项目结构）
- `fe-vue3-demo/docs/ai-context/project-structure.md`（Vue3 项目结构）

### 2. 分析功能需求

根据用户描述的新功能，分析：
- 功能模块归属（应放在哪个子项目的哪个目录）
- 涉及的组件层次
- 数据流设计
- API 接口需求

### 3. 提供开发建议

基于文档和需求分析，提供：
- 目录结构建议
- 组件设计方案
- 命名约定（遵循编码规范）
- 实现步骤

---

## 输出格式

```markdown
## 新功能开发方案

### 需求分析
[对功能需求的理解]

### 模块归属
[建议的目录位置，明确是哪个子项目，参考项目结构文档]

### 组件设计
[组件划分、命名、层次关系]

### 实现步骤
1. [第一步]
2. [第二步]
...

### 编码规范提示
[相关的命名约定、代码风格等，区分 Vue2/JS 和 Vue3/TS 规范]
```

---

## 注意事项

1. **遵循现有架构**：新功能需与现有架构风格保持一致
2. **编码规范**：严格遵守对应子项目的编码规范（Vue2/JS vs Vue3/TS）
3. **命名约定**：组件、变量、文件命名需符合规范
4. **可复用性**：考虑组件的复用可能性
5. **技术栈差异**：注意 Vue2（JS）和 Vue3（TS）的实现差异

---

## 相关文档

- [架构设计 - Vue2](fe-vue2-demo/docs/ai-context/architecture.md)
- [架构设计 - Vue3](fe-vue3-demo/docs/ai-context/architecture.md)
- [编码规范 - Vue2](fe-vue2-demo/docs/ai-context/coding-standards.md)
- [编码规范 - Vue3](fe-vue3-demo/docs/ai-context/coding-standards.md)
- [项目结构 - Vue2](fe-vue2-demo/docs/ai-context/project-structure.md)
- [项目结构 - Vue3](fe-vue3-demo/docs/ai-context/project-structure.md)
