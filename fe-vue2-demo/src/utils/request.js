import Vue from 'vue'

/**
 * HTTP 请求封装
 * 基于 fetch API 封装，提供统一的请求接口
 */

// 获取基础 URL（从环境变量读取）
const BASE_URL = process.env.VUE_APP_API_BASE_URL || ''

/**
 * 发起 HTTP 请求
 * @param {string} url - 请求路径
 * @param {Object} options - 请求配置
 * @param {string} options.method - 请求方法，默认 GET
 * @param {Object} options.data - 请求体数据（POST/PUT）
 * @param {Object} options.params - URL 查询参数
 * @returns {Promise} 返回响应数据
 */
export function request(url, options = {}) {
  const { method = 'GET', data, params } = options

  // 拼接完整 URL
  let fullUrl = BASE_URL + url

  // 处理 GET 请求的查询参数
  if (params && method === 'GET' && Object.keys(params).length > 0) {
    const queryString = Object.keys(params)
      .filter(key => params[key] !== undefined && params[key] !== null)
      .map(key => `${encodeURIComponent(key)}=${encodeURIComponent(params[key])}`)
      .join('&')
    if (queryString) {
      fullUrl += (fullUrl.includes('?') ? '&' : '?') + queryString
    }
  }

  // 构建请求配置
  const config = {
    method,
    headers: {
      'Content-Type': 'application/json'
    }
  }

  // POST/PUT 请求添加请求体
  if (data && (method === 'POST' || method === 'PUT')) {
    config.body = JSON.stringify(data)
  }

  // 发起请求
  return fetch(fullUrl, config)
    .then(response => {
      if (!response.ok) {
        throw new Error(`请求失败: ${response.status} ${response.statusText}`)
      }
      return response.json()
    })
    .then(res => {
      // 后端返回格式为 { code: 0, data: {}, message: '' }
      if (res.code !== 0 && res.code !== 200) {
        throw new Error(res.message || '请求失败')
      }
      return res.data
    })
    .catch(err => {
      // 请求错误，通过 toast 提示用户
      if (Vue.prototype.$toast) {
        Vue.prototype.$toast(err.message || '网络异常')
      }
      return Promise.reject(err)
    })
}

// 导出便捷方法
export const get = (url, params) => request(url, { method: 'GET', params })
export const post = (url, data) => request(url, { method: 'POST', data })
