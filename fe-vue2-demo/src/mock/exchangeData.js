/**
 * 兑换记录 Mock 数据
 * 用于开发/测试阶段模拟后端接口返回数据
 */

// 兑换状态枚举
export const STATUS_ENUM = {
  PENDING: '待发放',
  PROCESSING: '发放中',
  COMPLETED: '已发放',
  FAILED: '发放失败'
}

// Mock 兑换记录列表
export const mockRecords = [
  {
    id: 1,
    date: '2024-12-02 17:05:22',
    name: '100元礼品卡',
    code: '1VSDFS32FFWFSDFSFS1',
    amount: '500',
    status: STATUS_ENUM.PENDING
  },
  {
    id: 2,
    date: '2024-12-02 17:05:23',
    name: '200元礼品卡',
    code: '1VSDFS32FFWFSDFSFS2',
    amount: '600',
    status: STATUS_ENUM.COMPLETED
  },
  {
    id: 3,
    date: '2024-12-02 17:05:24',
    name: '300元礼品卡',
    code: '1VSDFS32FFWFSDFSFS3',
    amount: '700',
    status: STATUS_ENUM.PROCESSING
  },
  {
    id: 4,
    date: '2024-12-01 10:30:15',
    name: '50元优惠券',
    code: 'CPN50ABCDEFGH1234',
    amount: '200',
    status: STATUS_ENUM.COMPLETED
  },
  {
    id: 5,
    date: '2024-11-30 14:22:08',
    name: '500元购物卡',
    code: 'GC500XYZMNOP56789',
    amount: '2000',
    status: STATUS_ENUM.FAILED
  }
]

/**
 * 模拟分页数据
 * @param {number} page - 页码
 * @param {number} pageSize - 每页条数
 * @returns {Object} 分页结果
 */
export function getMockRecordsWithPagination(page = 1, pageSize = 10) {
  const start = (page - 1) * pageSize
  const end = start + pageSize
  const list = mockRecords.slice(start, end)

  return {
    list,
    total: mockRecords.length,
    page,
    pageSize,
    totalPages: Math.ceil(mockRecords.length / pageSize)
  }
}

/**
 * 根据状态筛选 mock 数据
 * @param {string} status - 状态筛选条件
 * @returns {Array} 筛选后的数据
 */
export function filterMockRecordsByStatus(status) {
  if (!status) return mockRecords
  return mockRecords.filter(item => item.status === status)
}
