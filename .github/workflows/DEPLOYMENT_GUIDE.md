# TODO 待验证 - 部署指南

> 本文档说明如何配置 GitHub Actions 部署到 Staging 和 Production 环境

---

## GitHub Environments 配置

在开始部署前，需要在 GitHub 仓库中配置 Environments：

### 1. 配置 Staging 环境

1. 进入 GitHub 仓库 → Settings → Environments
2. 点击 "New environment"，命名为 `staging`
3. 配置以下选项：
   - **Deployment branches**: 选择 "Only selected branches"，勾选 `develop`
   - **Environment variables**: 添加部署需要的环境变量
   - **Deployment secrets**: 添加部署需要的密钥

### 2. 配置 Production 环境

1. 进入 GitHub 仓库 → Settings → Environments
2. 点击 "New environment"，命名为 `production`
3. 配置以下选项：
   - **Required reviewers**: 建议指定审核人员（生产部署需要审批）
   - **Deployment branches**: 选择 "Only selected branches"，勾选 `main`
   - **Environment variables**: 添加生产环境变量
   - **Deployment secrets**: 添加生产环境密钥

---

## 部署配置方式

### 方式一：SSH 部署（推荐）

1. 在服务器上生成 SSH key 对
2. 将公钥添加到 GitHub 仓库的 Deploy Keys
3. 在 GitHub Environment Secrets 中添加：
   - `SSH_HOST`: 服务器地址
   - `SSH_USER`: SSH 用户名
   - `SSH_KEY`: SSH 私钥
   - `DEPLOY_PATH`: 部署路径

4. 在 `ci-cd.yml` 中替换部署步骤：

```yaml
- name: 部署到 Staging 环境
  uses: appleboy/ssh-action@master
  with:
    host: ${{ secrets.SSH_HOST }}
    username: ${{ secrets.SSH_USER }}
    key: ${{ secrets.SSH_KEY }}
    script: |
      cd ${{ secrets.DEPLOY_PATH }}
      rm -rf dist/*
      cp -r /tmp/dist/* ./dist/
```

### 方式二：rsync 部署

```yaml
- name: 部署到 Staging 环境
  run: |
    mkdir -p ~/.ssh
    echo "${{ secrets.SSH_KEY }}" > ~/.ssh/id_rsa
    chmod 600 ~/.ssh/id_rsa
    rsync -avz --delete ./fe-vue2-demo/dist/ ${{ secrets.SSH_USER }}@${{ secrets.SSH_HOST }}:${{ secrets.DEPLOY_PATH }}/
```

### 方式三：静态托管平台

#### Netlify
```yaml
- name: 部署到 Netlify
  uses: nwtgck/actions-netlify@v2
  with:
    publish-dir: './fe-vue2-demo/dist'
    production-branch: main
    github-token: ${{ secrets.GITHUB_TOKEN }}
    deploy-message: "Deploy from GitHub Actions"
  env:
    NETLIFY_AUTH_TOKEN: ${{ secrets.NETLIFY_AUTH_TOKEN }}
    NETLIFY_SITE_ID: ${{ secrets.NETLIFY_SITE_ID }}
```

#### Vercel
```yaml
- name: 部署到 Vercel
  uses: amondnet/vercel-action@v20
  with:
    vercel-token: ${{ secrets.VERCEL_TOKEN }}
    vercel-org-id: ${{ secrets.VERCEL_ORG_ID }}
    vercel-project-id: ${{ secrets.VERCEL_PROJECT_ID }}
    vercel-args: '--prod'
    working-directory: ./fe-vue2-demo
```

#### 阿里云 OSS
```yaml
- name: 部署到阿里云 OSS
  uses: manyuanrong/setup-ossutil@v3.0
  with:
    endpoint: oss-cn-hangzhou.aliyuncs.com
    access-key-id: ${{ secrets.OSS_ACCESS_KEY_ID }}
    access-key-secret: ${{ secrets.OSS_ACCESS_KEY_SECRET }}
- name: 上传到 OSS
  run: ossutil cp -r ./fe-vue2-demo/dist oss://${{ secrets.OSS_BUCKET_NAME }}/ --recursive --force
```

---

## 部署 Secrets 配置

在 GitHub Environment Secrets 中添加以下密钥：

### 通用密钥（两个环境都需要）
| 密钥名 | 说明 |
|--------|------|
| `SSH_KEY` | SSH 私钥（用于部署） |

### 按部署方式选择
| 密钥名 | 用途 | 适用部署方式 |
|--------|------|--------------|
| `SSH_HOST` | 服务器地址 | SSH/rsync |
| `SSH_USER` | SSH 用户名 | SSH/rsync |
| `NETLIFY_AUTH_TOKEN` | Netlify 认证 Token | Netlify |
| `NETLIFY_SITE_ID` | Netlify 站点 ID | Netlify |
| `VERCEL_TOKEN` | Vercel Token | Vercel |
| `VERCEL_ORG_ID` | Vercel 组织 ID | Vercel |
| `VERCEL_PROJECT_ID` | Vercel 项目 ID | Vercel |
| `OSS_ACCESS_KEY_ID` | 阿里云 AccessKey ID | 阿里云 OSS |
| `OSS_ACCESS_KEY_SECRET` | 阿里云 AccessKey Secret | 阿里云 OSS |
| `OSS_BUCKET_NAME` | 阿里云 Bucket 名称 | 阿里云 OSS |

---

## 手动触发部署

除了自动触发外，还可以手动触发部署：

### 方式一：GitHub UI
1. 进入仓库 → Actions → CI/CD Pipeline
2. 点击 "Run workflow" 按钮
3. 选择分支和环境

### 方式二：使用 workflow_dispatch

如果需要手动触发，可以在 `ci-cd.yml` 中添加：

```yaml
on:
  workflow_dispatch:
    inputs:
      environment:
        description: '部署环境'
        required: true
        type: choice
        options:
          - staging
          - production
      branch:
        description: '部署分支'
        required: true
        default: 'develop'
```

---

## 故障排查

### 部署失败
- 检查 Environment 配置是否正确
- 检查 Secrets 是否配置
- 检查 SSH 权限是否正确
- 查看部署日志

### 构建失败
- 检查 Node.js 版本是否兼容
- 检查依赖是否正确安装
- 检查构建命令是否正确

---

## 相关文档

- [GitHub Environments 文档](https://docs.github.com/en/actions/deployment/targeting-different-environments/using-environments-for-deployment)
- [项目部署脚本](../../deploy.sh)
- [SECRETS_GUIDE.md](./SECRETS_GUIDE.md) - Secrets 配置指南
