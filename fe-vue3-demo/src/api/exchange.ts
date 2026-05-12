import { get, post } from '@/utils/request';
import type { PaginationParams, PaginationResult, SubmitResult } from '@/mock';
import { getMockRecordsWithPagination } from '@/mock';

// 是否使用 mock 数据（通过环境变量控制）
const USE_MOCK = import.meta.env.VITE_USE_MOCK === 'true';

/**
 * 获取兑换记录列表
 */
export function getExchangeRecords(params: PaginationParams = {}): Promise<PaginationResult> {
  if (USE_MOCK) {
    return Promise.resolve(getMockRecordsWithPagination(params.page, params.pageSize));
  }

  return get<PaginationResult>('/api/exchange-records', params as Record<string, unknown>);
}

/**
 * 提交兑换记录（示例扩展接口）
 */
export function submitExchangeRecord(data: Record<string, unknown>): Promise<SubmitResult> {
  if (USE_MOCK) {
    return Promise.resolve({ success: true });
  }

  return post<SubmitResult>('/api/exchange-records', data);
}