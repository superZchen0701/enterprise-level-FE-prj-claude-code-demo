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

首先读取项目的编码规范文档：
- `@docs/ai-context/coding-standards.md`

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

### 4. 逐个审查文件

依据 `@docs/ai-context/coding-standards.md` 规范，对每个变更文件执行检查。

### 5. 生成审查报告

按指定格式输出审查结果。

---

## 输出格式

```markdown
## PR 代码审查报告

### 目标分支
develop

### 变更文件
- fe-vue2-demo/src/components/UserInfo.vue
- fe-vue2-demo/src/utils/auth.js
- .github/workflows/ci-cd.yml

### 发现的问题

#### fe-vue2-demo/src/components/UserInfo.vue
- ❌ [文件命名] 组件文件应使用 PascalCase 命名（违反规范 3.1）
  建议：重命名为 `UserInfo.vue`

- ❌ [props 定义] prop 缺少类型定义和默认值（违反规范 4.2）
  建议：`props: { userName: { type: String, default: '' } }`

#### .github/workflows/ci-cd.yml
- ⚠️ [配置检查] 建议检查 secrets 引用是否正确

### 总结
| 类型 | 数量 |
|------|------|
| ✅ 通过项 | 5 |
| ⚠️ 警告项 | 1 |
| ❌ 错误项 | 2 |
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

---

## 相关文档

- [编码规范](@docs/ai-context/coding-standards.md)
- [项目结构](@docs/ai-context/project-structure.md)
