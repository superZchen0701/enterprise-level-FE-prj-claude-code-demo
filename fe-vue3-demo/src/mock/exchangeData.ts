/** 兑换记录 */
export interface ExchangeRecord {
  id: number
  date: string
  name: string
  code: string
  amount: string
  status: string
}

/** 分页查询参数 */
export interface PaginationParams {
  page?: number
  pageSize?: number
  status?: string
}

/** 分页查询结果 */
export interface PaginationResult {
  list: ExchangeRecord[]
  total: number
  page: number
  pageSize: number
  totalPages: number
}

/** 提交操作结果 */
export interface SubmitResult {
  success: boolean
}

// 兑换状态枚举
export const STATUS_ENUM = {
  PENDING: '待发放',
  PROCESSING: '发放中',
  COMPLETED: '已发放',
  FAILED: '发放失败',
} as const;

// Mock 兑换记录列表
export const mockRecords: ExchangeRecord[] = [
  {
    id: 1,
    date: '2024-12-02 17:05:22',
    name: '100元礼品卡',
    code: '1VSDFS32FFWFSDFSFS1',
    amount: '500',
    status: STATUS_ENUM.PENDING,
  },
  {
    id: 2,
    date: '2024-12-02 17:05:23',
    name: '200元礼品卡',
    code: '1VSDFS32FFWFSDFSFS2',
    amount: '600',
    status: STATUS_ENUM.COMPLETED,
  },
  {
    id: 3,
    date: '2024-12-02 17:05:24',
    name: '300元礼品卡',
    code: '1VSDFS32FFWFSDFSFS3',
    amount: '700',
    status: STATUS_ENUM.PROCESSING,
  },
  {
    id: 4,
    date: '2024-12-01 10:30:15',
    name: '50元优惠券',
    code: 'CPN50ABCDEFGH1234',
    amount: '200',
    status: STATUS_ENUM.COMPLETED,
  },
  {
    id: 5,
    date: '2024-11-30 14:22:08',
    name: '500元购物卡',
    code: 'GC500XYZMNOP56789',
    amount: '2000',
    status: STATUS_ENUM.FAILED,
  },
];

/**
 * 模拟分页数据
 */
export function getMockRecordsWithPagination(page: number = 1, pageSize: number = 10): PaginationResult {
  const start = (page - 1) * pageSize;
  const end = start + pageSize;
  const list = mockRecords.slice(start, end);

  return {
    list,
    total: mockRecords.length,
    page,
    pageSize,
    totalPages: Math.ceil(mockRecords.length / pageSize),
  };
}

/**
 * 根据状态筛选 mock 数据
 */
export function filterMockRecordsByStatus(status: string): ExchangeRecord[] {
  if (!status) return mockRecords;
  return mockRecords.filter(item => item.status === status);
}