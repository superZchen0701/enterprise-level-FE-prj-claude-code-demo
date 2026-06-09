# pr-code-review 技能

**描述**：审查当前 PR 的全部变更文件，依据项目编码规范进行检查并生成审查报告。

**触发机制**：
1. **手动触发**：用户输入 `/pr-code-review` 直接调用
2. **CI/CD 触发**：GitHub Actions PR 代码审查阶段自动执行

---

## 前置条件

- 当前分支有相对于目标分支（develop/main）的代码变更
- 如果没有任何变更，提示用户当前 PR 没有代码改动

---

## 执行步骤

### 1. 读取编码规范

读取**所有涉及变更的子项目**的编码规范文档：
- 如果 `fe-vue2-demo/` 有变更 → `fe-vue2-demo/docs/ai-context/coding-standards.md`
- 如果 `fe-vue3-demo/` 有变更 → `fe-vue3-demo/docs/ai-context/coding-standards.md`

### 2. 确定目标分支

通过 git 命令确定 PR 的目标分支：
```bash
git rev-parse --abbrev-ref HEAD
```
然后根据当前分支推断目标分支（通常为 develop 或 main），或直接使用：
```bash
git diff --name-only origin/develop...HEAD
```

如果 origin/develop 不存在，尝试 origin/main。

### 3. 获取 PR 全部变更文件

执行命令获取当前分支相对于目标分支的所有变更文件：
```bash
git diff --name-only origin/develop...HEAD
```

**不限制目录**：审查所有变更文件，不局限于 `src/` 目录。包括配置文件、脚本、工作流文件等。

如果筛选后为空，提示用户当前 PR 没有代码改动需要审查。

### 4. 按子项目分组审查

将变更文件按子项目分组，依据对应子项目的编码规范执行检查。

### 5. 移动端 UI 专项审查

如果变更文件中包含 `.vue` 文件，**必须**调用 `mobile-ui-reviewer` agent 并行执行 UI 专项审查：

```
Agent({
  subagent_type: "mobile-ui-reviewer",
  prompt: "审查当前 PR 中变更的 .vue 文件的移动端 UI 问题，重点关注 Vant 组件用法、响应式适配和可访问性。变更文件列表：<文件列表>"
})
```

将 mobile-ui-reviewer 的审查结果合并到最终报告中，作为独立的「移动端 UI 审查」章节。

### 6. 生成审查报告

按指定格式输出审查结果。

---

## 输出格式

```markdown
## PR 代码审查报告

### 目标分支
develop

### 变更文件
- fe-vue2-demo/src/components/UserInfo.vue
- fe-vue3-demo/src/utils/auth.ts
- .github/workflows/ci-cd.yml

### 发现的问题

#### fe-vue2-demo/src/components/UserInfo.vue
- ❌ [文件命名] 组件文件应使用 PascalCase 命名（违反规范 3.1）
  建议：重命名为 `UserInfo.vue`

#### fe-vue3-demo/src/utils/auth.ts
- ⚠️ [类型注解] 函数缺少返回类型声明（违反 TypeScript 规范）
  建议：添加 `Promise<AuthResult>` 返回类型

#### .github/workflows/ci-cd.yml
- ⚠️ [配置检查] 建议检查 secrets 引用是否正确

### 总结
| 类型 | 数量 |
|------|------|
| ✅ 通过项 | 5 |
| ⚠️ 警告项 | 1 |
| ❌ 错误项 | 2 |

---

## 移动端 UI 审查（仅当变更包含 .vue 文件时）

> 以下内容由 mobile-ui-reviewer agent 生成

### 问题

| 严重程度 | 文件 | 行号 | 问题描述 | 建议修复 |
|----------|------|------|----------|----------|
| ... | ... | ... | ... | ... |

### 总结

[移动端 UI 审查总结]
```

---

## 注意事项

1. **审查范围**：审查当前 PR 相对于目标分支的**全部变更文件**，不限于特定目录
2. **目标分支**：优先使用 develop 作为目标分支，如不存在则使用 main
3. **无变更文件**：如果没有任何变更，提示用户当前 PR 没有需要审查的代码
4. **安全问题**：发现硬编码敏感信息（密钥、密码、token）时必须明确指出并要求立即修复
5. **建议粒度**：每个问题必须给出具体的修复建议或代码示例
6. **规范引用**：指出问题时应标注违反的具体规范条款编号
7. **配置文件**：审查 CI/CD 配置、环境变量、脚本文件时关注安全和最佳实践
8. **子项目差异**：注意 Vue2/JS 和 Vue3/TS 的规范差异，分别审查

---

## 相关文档

- [编码规范 - Vue2](fe-vue2-demo/docs/ai-context/coding-standards.md)
- [编码规范 - Vue3](fe-vue3-demo/docs/ai-context/coding-standards.md)
- [项目结构 - Vue2](fe-vue2-demo/docs/ai-context/project-structure.md)
- [项目结构 - Vue3](fe-vue3-demo/docs/ai-context/project-structure.md)
