---
name: security-review
description: 执行代码安全审查，检查敏感信息、安全漏洞和最佳实践
category: Security
tags: [security, review, audit]
---

# 安全审查技能

**描述**：对项目根目录下的所有代码进行安全审查，检查敏感信息泄露、安全漏洞和编码最佳实践。

**触发方式**：
- 手动触发：用户输入 `/security-review`
- 关键词触发：输入包含"安全审查"、"安全检查"、"安全扫描"等
- CI/CD 自动触发：GitHub Actions 安全扫描阶段

---

## ⚠️ 重要注意事项

**禁止使用 worktree 隔离模式**

执行本命令时：
- 不要使用 `isolation: "worktree"` 参数
- 不要创建新的 git worktree
- 直接在当前工作目录中执行审查

原因：
- 安全审查只涉及读取文件和运行只读命令
- worktree 会在父目录创建额外分支，污染仓库结构
- 使用 `Read`、`Grep`、`Glob` 和只读 `Bash` 命令即可完成审查

---

## 前置条件

- 项目目录下必须有代码文件
- 如果是 CI/CD 环境，需要已安装依赖（node_modules 存在）

---

## 执行步骤

### 1. 获取审查范围

首先检查 git 仓库状态，确定审查范围：

```bash
# 检查是否有 git 提交记录
git rev-parse HEAD 2>/dev/null
```

**情况 A：有提交记录（CI/CD 环境或已有提交的本地仓库）**

```bash
# 获取所有改动的文件（包括已暂存和未暂存的）
git diff HEAD --name-only
```

**情况 B：无提交记录（新仓库）或没有远程仓库**

```bash
# 获取所有已跟踪的文件
git ls-files --cached

# 获取所有未跟踪的文件
git ls-files --others --exclude-standard
```

**筛选审查范围**：审查项目根目录下所有 `.vue`、`.js`、`.ts`、`.jsx`、`.tsx`、`.json`、`.sh` 文件。

**排除目录**：
- `node_modules/` - 依赖目录
- `dist/` - 构建输出目录
- `.git/` - Git 元数据
- `coverage/` - 测试覆盖率报告
- `*.log` - 日志文件

如果筛选后为空，审查当前所有代码文件。

### 2. 执行安全检查

对每个文件执行以下检查：

#### 2.1 敏感信息检查

检查是否存在硬编码的敏感信息：

| 检查项 | 关键词/模式 | 排除项 |
|--------|-----------|--------|
| API 密钥 | `API_KEY`, `API_SECRET`, `apikey`, `api_secret` | `process.env`, `VUE_APP_`, `import`, `defineProps`, `props` |
| 密码 | `PASSWORD`, `PASSWD`, `pwd`, `password` | `process.env`, `VUE_APP_`, 注释 |
| Token | `TOKEN`, `SECRET_TOKEN`, `access_token`, `refresh_token` | `process.env`, `VUE_APP_`, `import`, 变量名 |
| 私钥 | `PRIVATE_KEY`, `RSA_PRIVATE`, `BEGIN.*PRIVATE` | - |
| AWS 凭证 | `AKIA[0-9A-Z]{16}`, `aws_secret` | `process.env` |
| 数据库连接 | `mongodb://`, `mysql://`, `postgres://` 含密码 | `process.env` |
| 第三方服务密钥 | `firebase`, `algolia`, `stripe` 等配置中的密钥 | `process.env` |

#### 2.2 安全漏洞检查

| 检查项 | 检查内容 | 风险等级 |
|--------|---------|---------|
| XSS 风险 | `v-html`、`innerHTML`、`dangerouslySetInnerHTML` | 高 |
| 不安全的正则 | `new RegExp(userInput)` | 中 |
| eval 执行 | `eval()`, `Function()`, `setTimeout(string)` | 高 |
| 路径遍历 | 用户输入直接拼接到文件路径 | 中 |
| SQL 注入 | 用户输入直接拼接到 SQL 语句 | 高 |
| 不安全的 HTTP | `http://` 非 localhost 地址 | 低 |
| 禁用 SSL 验证 | `rejectUnauthorized: false` | 中 |
| 弱随机数 | `Math.random()` 用于安全场景 | 中 |

#### 2.3 最佳实践检查

| 检查项 | 检查内容 |
|--------|---------|
| console 语句 | `console.log`, `console.debug`（生产环境应移除） |
| debugger | `debugger` 语句（生产环境应移除） |
| TODO/FIXME | 标记为待处理的代码 |
| 任何禁用 ESLint 的行 | `eslint-disable`, `eslint-ignore` |

### 3. 生成审查报告

按以下格式输出审查结果：

```markdown
## 安全审查报告

### 审查概览
- **审查时间**: YYYY-MM-DD HH:mm:ss
- **审查文件数**: X
- **环境**: CI/CD 或 Local

### 审查文件列表
- src/utils/auth.js
- src/components/UserInfo.vue
- ...

### 发现的问题

#### 🔴 高风险问题

**[文件路径]**
- ❌ [问题类型] 问题描述
  位置：第 X 行
  建议：修复建议

#### 🟡 中风险问题

**[文件路径]**
- ⚠️ [问题类型] 问题描述
  位置：第 X 行
  建议：修复建议

#### 🟢 低风险问题

**[文件路径]**
- ℹ️ [问题类型] 问题描述
  位置：第 X 行
  建议：修复建议

### 统计汇总
| 风险等级 | 数量 |
|----------|------|
| 🔴 高风险 | X |
| 🟡 中风险 | X |
| 🟢 低风险 | X |
| ✅ 通过项 | X |

### 修复建议
1. 优先修复高风险问题
2. ...

---
*此报告由 /security-review 命令自动生成*
```

---

## 输出模式

### CI/CD 模式

当检测到 `CI=true` 环境变量时：

1. 输出精简版报告（适合日志显示）
2. 发现高风险问题时返回非零退出码
3. 生成 SARIF 格式报告（可选，用于 GitHub Security 集成）

```bash
# CI 模式下生成 SARIF 报告
echo "::group::安全审查报告"
# ... 输出报告内容
echo "::endgroup::"

# 如果有高风险问题
if [ $HIGH_RISK_COUNT -gt 0 ]; then
  echo "::error::发现 $HIGH_RISK_COUNT 个高风险问题"
  exit 1
fi
```

### 本地模式

本地运行时输出完整报告，并提供交互式修复建议。

---

## 使用示例

### 示例 1：完整审查

```bash
/security-review
```

### 示例 2：审查指定文件

```bash
/security-review src/utils/request.js src/api/*.js
```

### 示例 3：仅检查敏感信息

```bash
/security-review --check secrets
```

---

## 与其他工具集成

### GitHub Actions

在 GitHub Actions 中使用时，审查结果会：
1. 输出到 Actions 日志
2. 上传为 Artifact（`security-review-report.md`）
3. 可选：生成 SARIF 文件并上传到 GitHub Security

### ESLint 插件

建议配合以下 ESLint 插件使用：
- `eslint-plugin-security`：安全规则检查
- `eslint-plugin-no-secrets`：敏感信息检查

---

## 注意事项

1. **误报处理**：某些检查可能产生误报，需要人工确认
2. **环境变量**：推荐使用环境变量管理敏感信息
3. **.env 文件**：确保 `.env*` 文件已添加到 `.gitignore`
4. **定期审查**：建议每次 PR 都运行安全审查

---

## 相关文档

- [编码规范](@docs/ai-context/coding-standards.md)
- [代码审查技能](../skills/code-review/skill.md)
