/** 请求配置选项 */
export interface RequestOptions {
  method?: string
  data?: Record<string, unknown>
  params?: Record<string, unknown>
  timeout?: number
}

/** 后端 API 响应格式 */
interface ApiResponse {
  code: number
  data: unknown
  message: string
}

// 获取基础 URL（从环境变量读取）
const BASE_URL: string = import.meta.env.VITE_API_BASE_URL || ''

/**
 * 发起 HTTP 请求
 * 基于 fetch API 封装，提供统一的请求接口
 */
export function request<T = unknown>(url: string, options: RequestOptions = {}): Promise<T> {
  const { method = 'GET', data, params, timeout = 15000 } = options

  // 拼接完整 URL
  let fullUrl = BASE_URL + url

  // 处理 GET 请求的查询参数
  if (params && method === 'GET' && Object.keys(params).length > 0) {
    const queryString = Object.keys(params)
      .filter(key => params[key] !== undefined && params[key] !== null)
      .map(key => `${encodeURIComponent(key)}=${encodeURIComponent(String(params[key]))}`)
      .join('&')
    if (queryString) {
      fullUrl += (fullUrl.includes('?') ? '&' : '?') + queryString
    }
  }

  // 构建请求配置，包含超时控制
  const controller = new AbortController()
  const timeoutId = setTimeout(() => controller.abort(), timeout)
  const config: RequestInit = {
    method,
    headers: {
      'Content-Type': 'application/json'
    },
    signal: controller.signal
  }

  // POST/PUT 请求添加请求体
  if (data && (method === 'POST' || method === 'PUT')) {
    config.body = JSON.stringify(data)
  }

  // 发起请求
  return fetch(fullUrl, config)
    .then(response => {
      clearTimeout(timeoutId)
      if (!response.ok) {
        throw new Error(`请求失败: ${response.status} ${response.statusText}`)
      }
      return response.json() as Promise<ApiResponse>
    })
    .then(res => {
      if (res.code !== 0 && res.code !== 200) {
        throw new Error(res.message || '请求失败')
      }
      return res.data as T
    })
    .catch(err => {
      clearTimeout(timeoutId)
      if (err.name === 'AbortError') {
        throw new Error('请求超时，请重试')
      }
      throw err
    })
}

// 导出便捷方法
export const get = <T = unknown>(url: string, params?: Record<string, unknown>): Promise<T> =>
  request<T>(url, { method: 'GET', params })

export const post = <T = unknown>(url: string, data?: Record<string, unknown>): Promise<T> =>
  request<T>(url, { method: 'POST', data })