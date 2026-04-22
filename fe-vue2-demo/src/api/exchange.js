import { get, post } from '@/utils/request'
import { mockRecords } from '@/mock'

// 是否使用 mock 数据（通过环境变量控制）
const USE_MOCK = process.env.VUE_APP_USE_MOCK === 'true'

/**
 * 获取兑换记录列表
 * @param {Object} params - 查询参数
 * @returns {Promise<Array>} 返回兑换记录列表
 */
export function getExchangeRecords(params = {}) {
  // 如果开启 mock，直接返回 mock 数据
  if (USE_MOCK) {
    return Promise.resolve(mockRecords)
  }

  // 调用真实 API
  return get('/api/exchange-records', params)
}

/**
 * 提交兑换记录（示例扩展接口）
 * @param {Object} data - 提交的数据
 * @returns {Promise<Object>} 返回操作结果
 */
export function submitExchangeRecord(data) {
  if (USE_MOCK) {
    // Mock 模式下直接返回成功
    return Promise.resolve({ success: true })
  }

  return post('/api/exchange-records', data)
}
