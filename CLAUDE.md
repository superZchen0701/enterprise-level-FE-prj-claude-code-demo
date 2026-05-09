# 团队项目 - Claude Code 配置

> **重要**：所有对话、解释、文档、代码注释、输出内容**必须全部使用简体中文**，禁止使用英文。

## 项目结构

本仓库为 pnpm monorepo，包含以下子项目：

| 子项目 | 技术栈 | 说明 |
|--------|--------|------|
| `fe-vue2-demo/` | Vue 2 + JavaScript | Vue 2 移动端项目 |
| `fe-vue3-demo/` | Vue 3 + TypeScript | Vue 3 移动端项目 |

各子项目的详细说明见对应目录下的 `CLAUDE.md`。

---

## 自动化规则

**规则配置详见：`.claude/hooks/keyword-trigger.js`**

当用户输入包含关键词时，系统会自动执行对应操作。如需新增规则，只需修改该文件即可。

---

## Git Hooks 配置

### 安装 Git Hooks

```bash
# 从仓库根目录执行，安装项目配置的 git hooks 到本地仓库
bash .claude/hooks/install-git-hooks.sh
```

### 已配置的 Hooks

| Hook | 说明 | 规范来源 |
|------|------|----------|
| `pre-commit` | 自动检测有变更的子项目并执行 lint | `@docs/ai-context/coding-standards.md` |
| `commit-msg` | 验证 commit message 格式 | `@docs/ai-context/coding-standards.md` |

---

## CI/CD 配置

### GitHub Actions 流水线

项目已配置完整的 CI/CD 流水线，包含 6 个阶段：

| 阶段 | 名称 | 调用命令 | 触发条件 |
|------|------|----------|----------|
| 1 | 代码检查 | `bash .claude/hooks/pre-commit.sh` | 仅推送 |
| 2 | 代码审查 | `/code-review` | 仅 PR |
| 3 | 安全扫描 | `bash .claude/hooks/security-review.sh` | 所有 PR 和推送 |
| 4 | 构建 | `pnpm run build` | 仅推送 |
| 5 | Staging 部署 | 部署脚本 | develop 分支推送 |
| 6 | Production 部署 | 部署脚本 | main 分支 推送 |

当提 PR 合并其他分支到 develop/main 分支时，GitHub 自动产生 push 事件，所以 push develop/main 已覆盖合并场景。

### 配置文件

| 文件 | 用途 |
|------|------|
| 仓库根目录下的 `.github/workflows/ci-cd.yml` | CI/CD 主配置文件 |
| 仓库根目录下的 `.github/workflows/DEPLOYMENT_GUIDE.md` | 部署 配置指南 |
| 仓库根目录下的 `.github/workflows/SECRETS_GUIDE.md` | Secrets 配置指南 |
| 仓库根目录下的 `deploy.sh` | 部署脚本模板 |

---

## 命名规范

### 一、命令命名规范

命令文件命名格式：`{序号}-{功能域}.md`

**序号规则**：
- 00-09：基础设施命令（help、setup）
- 10-19：开发命令（dev、build）
- 20-29：测试命令（test、lint）
- 30-39：部署命令（deploy、release）
- 40-49：数据命令（migrate、seed）
- 90-99：工具命令（debug、monitor）

**示例**：
```
.claude/commands/
├── 00-help.md                   # 帮助命令
├── 10-dev.md                    # 开发服务
├── 11-build.md                  # 构建命令
├── 20-test.md                   # 测试命令
├── 21-lint.md                   # 代码检查
├── 30-deploy.md                 # 部署命令
├── 31-release.md                # 发布命令
├── 40-migrate.md                # 数据迁移命令
├── 41-seed.md                   # 数据种子命令
└── 90-debug.md                  # 调试工具
```

### 二、技能命名规范

**1. 通用技能**

格式：`{功能}`，单词间用 `-` 连接

示例：
- `code-review`：代码审查
- `project-structure`：项目结构分析
- `feature-development`：新功能开发

**2. 项目特定技能**

格式：`{项目名}-{功能}`

示例：
- `ecommerce-checkout`：电商结算流程
- `cms-content-workflow`：CMS 内容工作流

---

## 项目可用技能列表

### 1. `/architecture` - 架构设计技能

**描述**：帮助用户进行架构设计，读取项目架构文档并提供架构设计建议。

**适用场景**：
- 理解当前项目架构
- 设计新的组件分层结构
- 数据流设计
- 选择合适的设计模式

---

### 2. `/code-commit` - 代码提交技能

**描述**：总结当前 git 变更记录，协助用户提交代码。

**适用场景**：
- 准备提交代码前，查看变更概览
- 生成符合规范的 commit message

---

### 3. `/code-review` - 代码审查技能

**描述**：审查 `src/` 目录下改动的代码，依据项目编码规范进行检查并生成审查报告。

**适用场景**：
- 提交前代码审查
- 检查代码是否符合编码规范
- 发现潜在问题和安全漏洞

**前置条件**：
- `src/` 目录下必须有改动的代码

---

### 4. `/feature-development` - 新功能开发技能

**描述**：帮助用户开发新功能，读取架构设计文档和编码规范，提供开发指导。

**适用场景**：
- 开发新功能前，了解模块归属
- 确定组件设计和实现步骤
- 获取命名约定和代码风格指导

---

### 5. `/project-structure` - 项目结构技能

**描述**：帮助用户理解项目结构，读取项目结构文档并提供模块说明。

**适用场景**：
- 了解项目目录结构
- 理解某个模块的职责
- 确定文件应该放在哪个目录

---

## 项目可用命令列表

暂无自定义命令
