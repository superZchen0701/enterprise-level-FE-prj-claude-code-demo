#!/usr/bin/env node
/**
 * 关键词检测脚本
 * 检测用户输入中的关键词，输出相应的自动操作指令
 *
 * 输出格式：
 * - 匹配时输出斜杠命令，Claude 会识别并执行对应的 Skill
 * - 无匹配时不输出任何内容
 */

// 从 stdin 或环境变量读取用户输入
let userInput = '';

// 优先检查环境变量是否存在（更可靠的方式）
// hook 系统可能通过环境变量传递用户输入
const envPrompt = process.env.USER_PROMPT || process.env.CLAUDE_PROMPT || '';

if (envPrompt) {
  // 如果环境变量有内容，直接使用
  userInput = envPrompt;
  checkKeywords(userInput);
} else if (process.stdin.isTTY) {
  // 如果是 TTY 模式且没有环境变量，无输入可处理
  process.exit(0);
} else {
  // 从 stdin 读取（异步）
  process.stdin.setEncoding('utf8');
  process.stdin.on('readable', () => {
    let chunk;
    while ((chunk = process.stdin.read()) !== null) {
      userInput += chunk;
    }
  });
  process.stdin.on('end', () => {
    checkKeywords(userInput);
  });
}

/**
 * 检测关键词并输出指令
 * 输出斜杠命令格式，便于 Claude 识别和执行
 */
function checkKeywords(input) {
  // 关键词映射规则
  // patterns: 精确匹配 - 输入包含任意一个字符串即触发
  // allOf: 宽松匹配 - 输入必须同时包含所有关键词才触发（顺序不限）
  // allOfAlt: 备选宽松匹配 - 多组 allOf 条件，任意一组满足即触发
  // skill: 对应的技能名称（用于斜杠命令）
  const rules = [
    {
      patterns: ['代码审查', '审查代码', '规范检查', 'lint检查', '代码规范', '检查规范', '代码检查'],
      allOf: ['检查', '规范'],
      skill: 'code-review',
      description: '代码审查'
    },
    {
      patterns: ['架构设计', '设计架构', '架构方案', '架构规划'],
      allOf: ['架构', '设计'],
      skill: 'architecture',
      description: '架构设计'
    },
    {
      patterns: ['开发新功能', '新功能开发', '功能开发', '开发功能'],
      allOf: ['开发', '功能'],
      skill: 'feature-development',
      description: '新功能开发'
    },
    {
      patterns: ['项目结构', '模块理解', '理解模块', '目录结构', '项目目录', '源码结构', '分析结构', '分析项目', '项目源码', '分析模块', '模块分析'],
      allOf: ['分析', '结构'],
      allOfAlt: [['分析', '结构'], ['分析', '模块']],
      skill: 'project-structure',
      description: '项目结构'
    }
  ];

  // 检测关键词并输出指令
  for (const rule of rules) {
    let matched = false;

    // 精确匹配：检查是否包含 patterns 中任意一个
    if (rule.patterns) {
      for (const pattern of rule.patterns) {
        if (input.includes(pattern)) {
          matched = true;
          break;
        }
      }
    }

    // 宽松匹配：检查是否同时包含 allOf 中所有关键词
    if (!matched && rule.allOf) {
      matched = rule.allOf.every(keyword => input.includes(keyword));
    }

    // 备选宽松匹配：检查多组 allOfAlt 条件，任意一组满足即触发
    if (!matched && rule.allOfAlt) {
      matched = rule.allOfAlt.some(group => group.every(keyword => input.includes(keyword)));
    }

    // 匹配成功，输出明确的执行指令
    if (matched) {
      // 输出格式：
      // 1. 杠命令标识（便于识别）
      // 2. 技能描述（用户可见）
      // 3. 执行指令（Claude 必须遵循）
      console.log(`Skill required: ${rule.skill}`);
      console.log(`[自动触发技能: ${rule.description}]`);
      console.log(`[必须立即调用 Skill 工具执行 ${rule.skill} 技能，不要跳过此步骤]`);
      process.exit(0);
    }
  }

  // 无匹配时不输出任何内容
  process.exit(0);
}