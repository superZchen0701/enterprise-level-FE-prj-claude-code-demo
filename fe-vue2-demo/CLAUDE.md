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

## 相关上下文文档

---

**处理代码相关任务时，请优先读取以下文档：**

| 文档 | 路径 | 用途 |
|-----|------|------|
| 项目结构 | `@docs/ai-context/project-structure.md` | 理解目录结构、技术栈 |
| 编码规范 | `@docs/ai-context/coding-standards.md` | 代码生成/审查依据 |
| 架构设计 | `@docs/ai-context/architecture.md` | 理解组件关系、数据流 |

---
