# enterprise-level-FE-prj-claude-code-demo

> Enterprise-level Front-end Project Claude Code Demo Repository

【Continuously Updating...】

## Project Overview

This repository is a Claude Code demo for enterprise-level front-end projects, demonstrating how to use Claude Code for efficient development in real-world projects. The repository includes a complete Vue 2 mobile application example, covering project architecture, coding standards, development workflows, and best practices.

## Repository Structure

| Directory | Description |
|-----------|-------------|
| `fe-vue2-demo/` | Mobile H5 application based on Vue 2 + Vant |
| `README.md` | Chinese Documentation |
| `README.en.md` | English Documentation |

## Development Guide

### Environment Requirements

- Node.js >= 20.19.0
- npm >= 10.1.0

### Recommended Tools

- Claude Code

## Claude Code Onboarding Checklist

### Step 1: Environment Setup

- [ ] Install Git, Node.js, npm, and OpenSpec.
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

- [ ] Run `npm install` locally to install dependencies and ensure they are properly installed; run `npm run serve` to start the development server.
- [ ] Try using OpenSpec commands for new feature development (type "/opsx:propose I need to develop a new feature: search function, which can search for redemption codes on the redemption record page. Requirements: 1. Use Vant's Search component. 2. Support real-time search.").
- [ ] Run relevant npm commands locally (such as `npm run lint`, `npm run serve`, `npm run build`, etc.) to verify the new feature works correctly.
- [ ] Submit a test PR to verify the CI process.

## Sub-projects

### fe-vue2-demo

A mobile application based on Vue 2 + Vant.

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

# Code linting
npm run lint

# Production build
npm run build
```

**Project Documentation:**

See: [fe-vue2-demo/README.md](fe-vue2-demo/README.md)

**Claude Code Configuration:**

See: [fe-vue2-demo/CLAUDE.md](fe-vue2-demo/CLAUDE.md)

**Related Resources:**

- [Vue 2 Official Documentation](https://v2.vuejs.org/)
- [Vant 2 Component Library](https://vant-contrib.gitee.io/vant/v2/)
- [Vue CLI Documentation](https://cli.vuejs.org/)
