# code-commit 技能

**描述**：总结当前 git 变更记录，协助用户提交代码。

**触发机制**：
1. **Hook 自动触发**：当用户输入包含关键词时，系统会输出 `<system-reminder>` 包含 `Skill required: code-commit`
2. **必须响应**：看到此提示后，必须立即调用 Skill 工具执行本技能，不要跳过此步骤
3. **手动触发**：用户可输入 `/code-commit` 直接调用

---

## 执行步骤

### 1. 获取 git 状态

执行以下命令获取当前仓库状态：

```bash
git status
```

### 2. 获取变更记录详情

如果有改动的文件，执行以下命令获取详细变更：

```bash
git diff HEAD
```

### 3. 总结变更记录

向用户展示：
- 改动的文件列表（分类：新增、修改、删除）
- 每个文件的主要变更内容
- 建议的 commit message

### 4. 询问用户确认

在总结变更后，询问用户：
- 是否确认提交所有改动？
- 是否需要调整 commit message？

### 5. 执行提交

用户确认后，执行提交操作：

```bash
git add <文件1> <文件2> ...
git commit -m "<type>(<tapdID>): <description>"
```

> **注意**：禁止使用 `git add .`，必须逐个指定具体文件，避免误提交敏感文件（如 .env、密钥文件等）。

**Commit Message 格式**（依据对应子项目的 `docs/ai-context/coding-standards.md`）：

---

## 输出格式

```markdown
## 变更记录总结

### 改动的文件

| 类型 | 文件 |
|------|------|
| 新增 | .claude/hooks/git-commit-msg.sh |
| 新增 | .claude/hooks/install-git-hooks.sh |
| 修改 | fe-vue3-demo/src/api/exchange.ts |
| ... | ... |

### 主要变更内容

**新增文件**：
- `.claude/hooks/git-commit-msg.sh` - Git commit message 验证脚本
- `.claude/hooks/install-git-hooks.sh` - Git hooks 安装脚本

**修改文件**：
- `fe-vue3-demo/src/api/exchange.ts` - 添加 TypeScript 类型定义

### 建议的 Commit Message

```
chore: 新增 git hooks 相关能力
```

---

是否确认提交以上改动？如需修改 commit message，请告知。
```

---

## 注意事项

1. **tapdID 必填**：commit message 中的 tapdID 是必填项，如果用户未提供，需要询问
2. **默认 type**：如果无法判断变更类型，默认为 `chore`
3. **敏感文件**：发现可能包含敏感信息的文件（如 `.env`、`*.key`、`*.pem` 等）时，需要警告用户不要提交
4. **大文件**：如果改动文件过大或过多，可以建议用户分批提交
5. **冲突检查**：提交前检查是否有合并冲突需要处理

---

## 相关文档

- [编码规范 - Vue2](fe-vue2-demo/docs/ai-context/coding-standards.md)
- [编码规范 - Vue3](fe-vue3-demo/docs/ai-context/coding-standards.md)
- [项目结构 - Vue2](fe-vue2-demo/docs/ai-context/project-structure.md)
- [项目结构 - Vue3](fe-vue3-demo/docs/ai-context/project-structure.md)
