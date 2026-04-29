# GitHub Actions CI/CD 配置指南

> 本文档说明如何配置 GitHub Actions CI/CD 流水线所需的 Secrets 和环境变量。

---

## 1. 快速开始

### 1.1 配置 Secrets

进入 GitHub 仓库设置页面：
```
Settings > Secrets and variables > Actions > New repository secret
```

添加以下 Secrets：

| Secret 名称 | 说明 | 获取方式 |
|------------|------|---------|
| `ANTHROPIC_AUTH_TOKEN` | API 密钥（兼容 Anthropic 及第三方网关） | 从你的模型提供商获取 |
| `ANTHROPIC_BASE_URL` | API 基础 URL（可选，第三方网关需要） | 从你的模型提供商获取 |
| `ANTHROPIC_MODEL` | 默认模型名称（如 `deepseek-v4-pro`） | 从你的模型提供商获取 |
| `ANTHROPIC_REASONING_MODEL` | 推理模型名称（如 `deepseek-v4-pro`） | 从你的模型提供商获取 |

---

## 2. 详细配置步骤

### 2.1 方案 A：使用第三方模型网关（如通义千问）

1. 从模型提供商获取配置信息
2. 复制以下信息：
   - **API 密钥**：`sk-xxx` 格式
   - **Base URL**：如 `你的 Base URL`
   - **模型名称**：如 `deepseek-v4-pro`

3. 添加到 GitHub Secrets：

| Secret 名称 | 示例值 |
|------------|--------|
| `ANTHROPIC_AUTH_TOKEN` | `sk-xxx` |
| `ANTHROPIC_BASE_URL` | `你的 Base URL` |
| `ANTHROPIC_MODEL` | `deepseek-v4-pro` |
| `ANTHROPIC_REASONING_MODEL` | `deepseek-v4-pro` |

### 2.2 方案 B：使用 Anthropic 官方 API

1. 访问 [Anthropic Console](https://console.anthropic.com/settings/keys)
2. 登录或注册 Anthropic 账户
3. 点击 "Create Key" 创建新的 API 密钥
4. 复制生成的密钥（格式类似：`sk-ant-api03-xxxxx...`）
5. **重要**：立即保存密钥，页面刷新后将无法再次查看完整密钥

添加到 GitHub Secrets：
1. 打开你的 GitHub 仓库
2. 点击 **Settings** 标签页
3. 在左侧菜单选择 **Secrets and variables** → **Actions**
4. 点击 **New repository secret** 按钮
5. 填写表单：
   - **Name**: `ANTHROPIC_AUTH_TOKEN`
   - **Secret**: 粘贴你的 API 密钥
6. 点击 **Add secret** 保存

> 注意：使用 Anthropic 官方 API 时，无需配置 `ANTHROPIC_BASE_URL`、`ANTHROPIC_MODEL`、`ANTHROPIC_REASONING_MODEL`

### 2.3 验证配置

配置完成后，你的 Secrets 列表应该显示：

```
Name                    Last Updated
ANTHROPIC_AUTH_TOKEN    Updated recently
ANTHROPIC_BASE_URL      Updated recently  （仅第三方网关需要）
```

---

## 3. CI/CD 流水线说明

### 3.1 流水线阶段

| 阶段 | 名称 | 调用命令 | 触发条件 |
|------|------|----------|----------|
| 1 | `lint` | `bash .claude/hooks/pre-commit.sh` | 所有 PR 和推送 |
| 2 | `code-review` | `/code-review` | 仅 PR |
| 3 | `security` | `/security-review` | 所有 PR 和推送 |
| 4 | `build` | `npm run build` | 所有 PR 和推送 |
| 5 | `deploy-staging` | 部署脚本 | develop 分支推送 |
| 6 | `deploy-production` | 部署脚本 | main 分支推送 |

### 3.2 Secrets 使用情况

| Secret | 使用阶段 | 用途 |
|--------|----------|------|
| `ANTHROPIC_AUTH_TOKEN` | `code-review`, `security` | API 认证令牌 |
| `ANTHROPIC_BASE_URL` | `code-review`, `security` | 第三方模型网关 Base URL（可选） |
| `ANTHROPIC_MODEL` | `code-review`, `security` | 默认模型名称 |
| `ANTHROPIC_REASONING_MODEL` | `code-review`, `security` | 推理模型名称 |

---

## 4. 常见问题

### Q1: 使用第三方模型网关如何配置？

按以下步骤配置：

1. **获取配置信息**：
   - `ANTHROPIC_AUTH_TOKEN`: `sk-xxx`（从你的提供商获取）
   - `ANTHROPIC_BASE_URL`: `你的 Base URL`

2. **添加到 GitHub Secrets**：
   - 添加 `ANTHROPIC_AUTH_TOKEN`
   - 添加 `ANTHROPIC_BASE_URL`

3. **验证配置**：
   - 手动触发 Workflow
   - 查看日志确认无认证错误

### Q2: 如何轮换 API 密钥？

1. 在模型提供商控制台创建新的 API 密钥
2. 在 GitHub Secrets 中更新 `ANTHROPIC_AUTH_TOKEN` 的值
3. 在模型提供商控制台删除旧密钥

### Q3: Workflow 运行失败，提示认证错误？

检查：
1. Secret 名称是否正确（区分大小写）
2. 是否在正确的仓库中配置
3. Secret 值是否完整复制（无多余空格）
4. 第三方网关的 Base URL 是否正确

### Q4: 如何测试配置是否正确？

手动触发 Workflow 测试：

1. 进入 **Actions** 标签页
2. 选择 **CI/CD Pipeline**
3. 点击 **Run workflow**
4. 选择分支后运行

查看 `code-review` 或 `security` 阶段的日志，确认无认证错误。

---

## 5. 安全最佳实践

### 5.1 保护 Secrets

- ✅ 不要将 Secret 提交到代码仓库
- ✅ 不要将 Secret 打印到日志中
- ✅ 定期轮换 API 密钥
- ✅ 限制有仓库访问权限的人员

### 5.2 最小权限原则

为 Workflow 配置最小必要权限：

```yaml
permissions:
  contents: read          # 读取代码
  pull-requests: write    # 评论 PR（仅 code-review 需要）
  security-events: write  # 上传安全报告（仅 security 需要）
```

---

## 6. 参考链接

- [GitHub Actions Secrets 文档](https://docs.github.com/en/actions/security-guides/encrypted-secrets)
- [claude-code-action 文档](https://github.com/anthropics/claude-code-action)
