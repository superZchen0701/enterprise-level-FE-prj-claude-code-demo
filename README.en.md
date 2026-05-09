# enterprise-level-FE-prj-claude-code-demo

> Enterprise-level Front-end Project Claude Code Demo Repository

【Continuously Updating...】

## Project Overview

This repository is a Claude Code demo for enterprise-level front-end projects, demonstrating how to use Claude Code for efficient development in real-world projects. The repository uses pnpm monorepo to manage multiple sub-projects, including: a Vue 2 mobile application example and a Vue 3 mobile application example. It covers project architecture, coding standards, development workflows, and best practices.

## Claude Code Onboarding Checklist

### Step 1: Environment Setup

- [ ] Install Git, Node.js, pnpm, and OpenSpec.
- [ ] Install Claude Code (refer to [Claude Code Official Documentation - Quick Start](https://code.claude.com/docs/zh-CN/quickstart)).
- [ ] Use CC Switch to manage multiple API model configurations (refer to [cc-switch](https://github.com/farion1231/cc-switch)).

### Step 2: Project Configuration

- [ ] Clone the project repository.
- [ ] Run the `claude` command to open the Claude Code interface.
- [ ] Run `!bash install.sh` to execute the one-click installation script.

### Step 3: Familiarize with Sub-project Standards

- [ ] Change directory to the corresponding sub-project (e.g., `cd fe-vue2-demo`).
- [ ] Read the `CLAUDE.md` file in the sub-project directory.
- [ ] Run `/help` to view available commands or skills.
- [ ] Try executing a project source code analysis (type "analyze project source code structure").

### Step 4: Develop New Features

- [ ] Create a local branch named `feat_xxx_tapdID`, where `xxx` is the feature name and `tapdID` is the Tapd task ID.
- [ ] Run `pnpm run serve` in the sub-project directory to start the development server.
- [ ] Try using OpenSpec commands for new feature development (type "/opsx:propose I need to develop a new feature: search function, which can search for redemption codes on the redemption record page. Requirements: 1. Use Vant's Search component. 2. Support real-time search.").
- [ ] Run relevant pnpm commands in the sub-project directory (`pnpm run serve`, `pnpm run lint`, `pnpm run build`, etc.) to verify the new feature works correctly.
- [ ] Commit code to the Git repository: type "Help me summarize the changes and commit the code" and follow the prompts.
- [ ] Create PRs: `feat_xxx_tapdID` branch to `develop` branch; `develop` branch to `main` branch; verify the CI/CD pipeline.

## Repository Structure

| Directory | Description |
|-----------|-------------|
| `fe-vue2-demo/` | Mobile H5 application based on Vue 2 + Vant 2 |
| `fe-vue3-demo/` | Mobile H5 application based on Vue 3 + Vant 4 |
| `package.json` | The package.json file in the project root, containing run scripts for all sub-projects |
| `.gitignore` | The Git ignore file in the project root, used to ignore files that should not be committed |
| `.npmrc` | The npm configuration file in the project root, used for global settings |
| `deploy.sh` | Deployment script used in .github/workflows/ci-cd.yml for deploying projects to corresponding environments |
| `install.sh` | One-click installation script for setting up the project environment dependencies |
| `README.md` | Chinese Documentation |
| `README.en.md` | English Documentation |
| `pnpm-workspace.yaml` | pnpm monorepo workspace configuration |

## Development Guide

### Environment Requirements

- Node.js >= 20.x
- pnpm >= 10.x

### Recommended Tools

- Claude Code
- pnpm (monorepo package manager)

## pnpm Monorepo

This project uses pnpm workspace to manage multiple sub-projects with unified dependency management.

### Install Dependencies

```bash
# Install dependencies for all sub-projects from the root
pnpm install
```

### Common Commands

```bash
# Start Vue 2 dev server
pnpm run dev:vue2

# Start Vue 3 dev server
pnpm run dev:vue3

# Build all projects
pnpm run build

# Lint all projects
pnpm run lint
```

## Sub-projects

### fe-vue2-demo

A mobile application based on Vue 2 + Vant 2.

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
pnpm run serve
```

**Project Documentation:**

See: [fe-vue2-demo/README.md](fe-vue2-demo/README.md)

**Claude Code Configuration:**

See: [fe-vue2-demo/CLAUDE.md](fe-vue2-demo/CLAUDE.md)

**Related Resources:**

- [Vue 2 Official Documentation](https://v2.vuejs.org/)
- [Vant 2 Component Library](https://vant-ui.github.io/vant/v2/#/zh-CN/)
- [Vue CLI Documentation](https://cli.vuejs.org/)

### fe-vue3-demo

A mobile application based on Vue 3 + Vant 4 (Composition API + Vite).

**Technology Stack:**

| Technology | Version | Description |
|------------|---------|-------------|
| Vue | 3.5.x | Front-end Framework (Composition API) |
| Vue Router | 4.x | Routing Management |
| Vant | 4.x | Mobile UI Component Library |
| Vite | 6.x | Build Tool |

**Quick Start:**

```bash
cd fe-vue3-demo
pnpm run serve
```

**Project Documentation:**

See: [fe-vue3-demo/README.md](fe-vue3-demo/README.md)

**Claude Code Configuration:**

See: [fe-vue3-demo/CLAUDE.md](fe-vue3-demo/CLAUDE.md)

**Related Resources:**

- [Vue 3 Official Documentation](https://cn.vuejs.org/)
- [Vant 4 Component Library](https://vant-ui.github.io/vant/#/zh-CN)
- [Vite Documentation](https://cn.vitejs.dev/)
