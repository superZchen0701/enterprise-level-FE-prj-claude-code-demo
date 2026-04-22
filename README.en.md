# enterprise-level-FE-prj-claude-code-demo

> Enterprise-level Front-end Project Claude Code Demo Repository

【Continuous Update...】

## Project Overview

This repository is a Claude Code demo for enterprise-level front-end projects, demonstrating how to use Claude Code for efficient development in real-world projects. The repository includes a complete Vue 2 mobile application example, covering project architecture, coding standards, development workflows, and best practices.

## Repository Structure

| Directory | Description |
|-----------|-------------|
| `fe-vue2-demo/` | Mobile H5 application based on Vue 2 + Vant |
| `README.md` | Chinese Documentation |
| `README.en.md` | English Documentation |

## Sub-projects

### fe-vue2-demo

A mobile application based on Vue 2 + Vant, featuring business modules such as exchange record tracking.

**Technology Stack:**

| Technology | Version | Description |
|------------|---------|-------------|
| Vue | 2.6.x | Front-end Framework |
| Vue Router | 3.x | Routing Management |
| Vant | 2.x | Mobile UI Component Library |
| Vue CLI | 5.x | Build Tool |

**Quick Start:**

```bash
cd fe-vue2-demo

# Install dependencies
npm install

# Development server
npm run serve

# Production build
npm run build
```

For detailed documentation, see: [fe-vue2-demo/README.md](fe-vue2-demo/README.md)

## Claude Code Configuration

### Language Rules

All conversations, explanations, documentation, and code comments in this repository **must be in Chinese (简体中文)**.

### Core Standards

- **Vue Components**: Use Options API, Composition API is prohibited
- **Naming Conventions**:
  - File names: kebab-case (e.g., `user-service.js`)
  - Component names: PascalCase (e.g., `UserCard.vue`)
  - Function/Variable names: camelCase (e.g., `getUserById`)
- **Git Commit**: `<type>(<TAPD ID>): <description>`

For detailed standards, see: [fe-vue2-demo/CLAUDE.md](fe-vue2-demo/CLAUDE.md)

## Project Documentation

Each sub-project includes a complete documentation system:

| Document | Description |
|----------|-------------|
| README.md | Project description and quick start guide |
| CLAUDE.md | Claude Code development behavior standards |
| docs/ai-context/ | AI context documents (project structure, coding standards, architecture design) |

## Development Guide

### Environment Requirements

- Node.js >= 14.x
- npm >= 6.x

### Recommended Tools

- VS Code + Volar Extension
- Terminal: Git Bash (Windows) or default terminal (macOS/Linux)

## Related Resources

- [Vue 2 Official Documentation](https://v2.vuejs.org/)
- [Vant 2 Component Library](https://vant-contrib.gitee.io/vant/v2/)
- [Vue CLI Documentation](https://cli.vuejs.org/)
