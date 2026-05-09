# Vue3 移动端项目 - Claude Code 配置

> 自动化规则、通用配置、技能/命令列表、命名规范等见仓库根目录 `CLAUDE.md`。本文档仅包含 Vue3 项目特有内容。

## 快速参考

### 核心命令
```bash
pnpm install          # 安装依赖
pnpm run dev          # 开发服务（热更新，默认开启 mock）
pnpm run serve        # 开发服务（热更新，默认开启 mock）
pnpm run build        # 生产构建
pnpm run lint         # 代码检查与修复
pnpm run typecheck    # TypeScript 类型检查
```

### 环境配置
| 文件 | 用途 |
|------|------|
| `.env.development` | 开发环境（默认 `VITE_USE_MOCK=true`） |
| `.env.production` | 生产环境（`VITE_USE_MOCK=false`） |

---

## 相关上下文文档

**处理代码相关任务时，请优先读取以下文档：**

| 文档 | 路径 | 用途 |
|-----|------|------|
| 项目结构 | `@docs/ai-context/project-structure.md` | 理解目录结构、技术栈 |
| 编码规范 | `@docs/ai-context/coding-standards.md` | 代码生成/审查依据 |
| 架构设计 | `@docs/ai-context/architecture.md` | 理解组件关系、数据流 |
