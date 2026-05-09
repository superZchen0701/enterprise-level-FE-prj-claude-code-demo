# code-review 技能

**描述**：审查所有子项目 `src/` 目录下改动的代码，依据项目编码规范进行检查并生成审查报告。

**适用范围**：本仓库为 monorepo，包含 `fe-vue2-demo/` 和 `fe-vue3-demo/` 两个子项目，代码审查必须覆盖**所有子项目**有变更的 `src/` 目录。

**触发机制**：
1. **Hook 自动触发**：当用户输入包含关键词时，系统会输出 `<system-reminder>` 包含 `Skill required: code-review`
2. **必须响应**：看到此提示后，必须立即调用 Skill 工具执行本技能，不要跳过此步骤
3. **手动触发**：用户可输入 `/code-review` 直接调用

---

## 前置条件

- `fe-vue2-demo/src/` 或 `fe-vue3-demo/src/` 目录下必须有改动的代码（包括已暂存和未暂存的改动）
- 必须同时检查两个子项目，不能只检查其中一个
- 如果所有子项目的 `src/` 目录都没有改动，提示用户当前没有代码改动需要审查

---

## 执行步骤

### 1. 读取编码规范

首先读取**所有有代码变更的子项目**的编码规范文档：
```bash
# 根据变更文件确定需要读取哪个子项目的规范
# fe-vue2-demo/src/ 有变更 → fe-vue2-demo/docs/ai-context/coding-standards.md
# fe-vue3-demo/src/ 有变更 → fe-vue3-demo/docs/ai-context/coding-standards.md
```

注意：两个子项目的规范可能有差异（如 Vue2/JS vs Vue3/TS），审查时需根据子项目特点分别判断。

### 2. 获取改动文件列表

首先检查仓库是否有提交记录：
```bash
git rev-parse HEAD 2>/dev/null
```

**情况 A：有提交记录**

执行命令获取所有已跟踪文件的改动：
```bash
git diff HEAD --name-only
```

同时检查未跟踪的文件：
```bash
git ls-files --others --exclude-standard
```

合并两者作为审查范围。

**情况 B：无提交记录（新仓库）**

获取所有已跟踪（暂存）的文件：
```bash
git diff --cached --name-only
```

获取所有未跟踪的文件：
```bash
git ls-files --others --exclude-standard
```

合并两者作为审查范围。

**筛选审查范围**：只审查 `fe-vue2-demo/src/` 和 `fe-vue3-demo/src/` 下的文件，过滤掉其他目录的文件。如果筛选后为空，提示用户当前没有代码改动需要审查。

### 3. 按子项目分组审查

将筛选后的变更文件按子项目分组：
- `fe-vue2-demo/` 下的文件使用 `fe-vue2-demo/docs/ai-context/coding-standards.md` 审查
- `fe-vue3-demo/` 下的文件使用 `fe-vue3-demo/docs/ai-context/coding-standards.md` 审查

依据对应子项目的编码规范，对每个改动文件执行检查。

### 4. 生成审查报告

按指定格式输出审查结果。

---

## 输出格式

```markdown
## 代码审查报告

### 审查文件
- fe-vue2-demo/src/components/UserInfo.vue
- fe-vue3-demo/src/utils/auth.ts

### 发现的问题

#### fe-vue2-demo/src/components/UserInfo.vue
- ❌ [文件命名] 组件文件应使用 PascalCase 命名（违反规范 3.1）
  建议：重命名为 `UserInfo.vue`

- ❌ [props 定义] prop 缺少类型定义和默认值（违反规范 4.2）
  建议：`props: { userName: { type: String, default: '' } }`

#### fe-vue3-demo/src/utils/auth.ts
- ⚠️ [类型注解] 函数缺少返回类型声明（违反 TypeScript 规范）
  建议：添加 `Promise<AuthResult>` 返回类型

### 总结
| 类型 | 数量 |
|------|------|
| ✅ 通过项 | 5 |
| ⚠️ 警告项 | 1 |
| ❌ 错误项 | 2 |
```

---

## 注意事项

1. **审查范围**：审查**所有子项目**（`fe-vue2-demo/src/` 和 `fe-vue3-demo/src/`）下改动的代码，不能遗漏任何子项目
2. **新仓库处理**：对于没有提交记录的新仓库，审查所有子项目 `src/` 下已暂存和未跟踪的文件
3. **无改动文件**：如果所有子项目的 `src/` 目录都没有代码改动，提示用户当前没有需要审查的代码
4. **安全问题**：发现硬编码敏感信息（密钥、密码、token）时必须明确指出并要求立即修复
5. **建议粒度**：每个问题必须给出具体的修复建议或代码示例
6. **规范引用**：指出问题时应标注违反的具体规范条款编号
7. **子项目差异**：注意两个子项目技术栈不同（Vue2/JS vs Vue3/TS），审查标准需区分对待

---

## 相关文档

- [编码规范 - Vue2](fe-vue2-demo/docs/ai-context/coding-standards.md)
- [编码规范 - Vue3](fe-vue3-demo/docs/ai-context/coding-standards.md)
- [项目结构 - Vue2](fe-vue2-demo/docs/ai-context/project-structure.md)
- [项目结构 - Vue3](fe-vue3-demo/docs/ai-context/project-structure.md)
