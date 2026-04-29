---
name: security-review
description: 执行代码安全审查，检查敏感信息、安全漏洞和最佳实践
category: Security
tags: [security, review, audit]
---

# 安全审查命令

执行 `.claude/hooks/security-review.sh` 脚本进行代码安全审查。

## 执行步骤

1. 运行安全审查脚本：
   ```bash
   bash .claude/hooks/security-review.sh
   ```

2. 根据脚本输出向用户展示审查结果，如发现高风险问题，提示用户优先修复。
