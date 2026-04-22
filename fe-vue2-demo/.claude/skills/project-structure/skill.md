# project-structure 技能

**描述**：帮助用户理解项目结构，读取项目结构文档并提供模块说明。

**触发机制**：
1. **Hook 自动触发**：当用户输入包含关键词时，系统会输出 `<system-reminder>` 包含 `Skill required: project-structure`
2. **必须响应**：看到此提示后，必须立即调用 Skill 工具执行本技能，不要跳过此步骤
3. **手动触发**：用户可输入 `/project-structure` 直接调用

---

## 前置条件

- 用户需要了解项目结构
- 用户需要理解某个模块的职责

---

## 执行步骤

### 1. 读取项目结构文档

首先读取项目的核心文档：

- `@docs/ai-context/project-structure.md`（项目结构）

### 2. 根据需要读取相关文档

根据用户的具体问题，可能还需要读取：

- `@docs/ai-context/architecture.md`（架构设计）
- `@docs/ai-context/coding-standards.md`（编码规范）

### 3. 分析用户需求

根据用户的问题类型，提供：
- 目录结构说明
- 模块职责解释
- 文件组织方式
- 路径别名配置

---

## 输出格式

```markdown
## 项目结构说明

### 目录概览
[主要目录及其职责]

### 模块分析
[用户询问的模块详情]

### 相关文件
[涉及的关键文件列表]

### 扩展建议
[如需要，提供如何扩展的建议]
```

---

## 注意事项

1. **结构一致性**：解释需与实际目录结构保持一致
2. **职责清晰**：明确说明每个模块的职责边界
3. **关联性**：说明模块之间的关系和依赖
4. **Vue2 特性**：结合 Vue2 项目特点解释目录组织

---

## 相关文档

- [项目结构](@docs/ai-context/project-structure.md)
- [架构设计](@docs/ai-context/architecture.md)
- [编码规范](@docs/ai-context/coding-standards.md)