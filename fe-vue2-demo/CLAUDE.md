# Vue2 移动端项目 - Claude Code 配置

> **重要**：所有对话、解释、文档、代码注释、输出内容**必须全部使用简体中文**，禁止使用英文。

## 快速参考

### 核心命令
```bash
npm install          # 安装依赖
npm run serve        # 开发服务（热更新，默认开启 mock）
npm run build        # 生产构建
npm run lint         # 代码检查与修复
```

### 环境配置
| 文件 | 用途 |
|------|------|
| `.env.development` | 开发环境（默认 `VUE_APP_USE_MOCK=true`） |
| `.env.production` | 生产环境（`VUE_APP_USE_MOCK=false`） |

---

## 自动化规则

**规则配置详见：`.claude/hooks/keyword-trigger.js`**

当用户输入包含关键词时，系统会自动执行对应操作。如需新增规则，只需修改该文件即可。

---

## Git Hooks 配置

### 安装 Git Hooks

```bash
# 安装项目配置的 git hooks 到本地仓库
bash .claude/hooks/install-git-hooks.sh
```

### 已配置的 Hooks

| Hook | 说明 | 规范来源 |
|------|------|----------|
| `pre-commit` | 执行 `npm run lint -- --fix` 自动修复代码 | `@docs/ai-context/coding-standards.md` |
| `commit-msg` | 验证 commit message 格式 | `@docs/ai-context/coding-standards.md` |

---

## CI/CD 配置

### GitHub Actions 流水线

项目已配置完整的 CI/CD 流水线，包含 6 个阶段：

| 阶段 | 名称 | 调用命令 | 触发条件 |
|------|------|----------|----------|
| 1 | 代码检查 | `bash .claude/hooks/pre-commit.sh` | 所有 PR 和推送 |
| 2 | 代码审查 | `/code-review` | 仅 PR |
| 3 | 安全扫描 | `/security-review` | 所有 PR 和推送 |
| 4 | 构建 | `npm run build` | 所有 PR 和推送 |
| 5 | Staging 部署 | 部署脚本 | develop 分支推送 |
| 6 | Production 部署 | 部署脚本 | main 分支推送 |

### 配置文件

| 文件 | 用途 |
|------|------|
| 仓库根目录下的 `.github/workflows/ci-cd.yml` | CI/CD 主配置文件 |
| 仓库根目录下的 `.github/workflows/DEPLOYMENT_GUIDE.md` | 部署 配置指南 |
| 仓库根目录下的 `.github/workflows/SECRETS_GUIDE.md` | Secrets 配置指南 |
| 仓库根目录下的 `deploy.sh` | 部署脚本模板 |

---

## 相关上下文文档

**处理代码相关任务时，请优先读取以下文档：**

| 文档 | 路径 | 用途 |
|-----|------|------|
| 项目结构 | `@docs/ai-context/project-structure.md` | 理解目录结构、技术栈 |
| 编码规范 | `@docs/ai-context/coding-standards.md` | 代码生成/审查依据 |
| 架构设计 | `@docs/ai-context/architecture.md` | 理解组件关系、数据流 |

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

### 1. `/security-review` - 安全审查命令

**描述**：对项目根目录下的所有代码进行安全审查，检查敏感信息泄露、安全漏洞和编码最佳实践。

**触发方式**：
- 手动触发：用户输入 `/security-review`
- 关键词触发：输入包含"安全审查"、"安全检查"、"安全扫描"等
- CI/CD 自动触发：GitHub Actions 安全扫描阶段
