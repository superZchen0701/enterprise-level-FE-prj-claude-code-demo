<template>
  <div class="exchange-record">
    <van-nav-bar title="兑换记录页" left-arrow @click-left="onClickLeft" />
    <div class="record-list">
      <div v-if="loading" class="loading-wrapper">
        <van-loading size="24px" vertical>列表加载中...</van-loading>
      </div>
      <van-cell v-else-if="records.length > 0" v-for="item in records" :key="item.id">
        <template #title>
          <div class="record-item">
            <div class="record-date">{{ item.date }}</div>
            <div class="record-content">
              <div class="record-left">
                <div class="record-name">{{ item.name }}</div>
                <div class="record-code">兑换码：{{ item.code }}</div>
              </div>
              <div class="record-right">
                <div class="record-amount">-{{ item.amount }}</div>
                <div class="record-status">{{ item.status }}</div>
              </div>
            </div>
          </div>
        </template>
      </van-cell>
      <div v-else class="empty-wrapper">
        <div class="empty-text">暂无兑换记录</div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import type { ExchangeRecord } from '@/mock'
import { getExchangeRecords } from '@/api/exchange'

const router = useRouter()
const records = ref<ExchangeRecord[]>([])
const loading = ref<boolean>(false)

function fetchRecords(): void {
  loading.value = true
  getExchangeRecords()
    .then(data => {
      records.value = data.list
    })
    .catch(err => {
      showToast((err as Error).message || '获取数据失败')
    })
    .finally(() => {
      loading.value = false
    })
}

// eslint-disable-next-line @typescript-eslint/no-unused-vars
function onClickLeft(): void {
  router.back()
}

onMounted(() => {
  fetchRecords()
})
</script>

<style scoped>
.exchange-record {
  background-color: #f7f8fa;
  min-height: 100vh;
}

.record-list {
  padding: 16px;
}

.loading-wrapper {
  display: flex;
  justify-content: center;
  align-items: center;
  padding: 60px 0;
}

.record-item {
  display: flex;
  flex-direction: column;
}

.record-date {
  color: #999;
  font-size: 14px;
  margin-bottom: 12px;
}

.record-content {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.record-left {
  flex: 1;
}

.record-right {
  text-align: right;
  margin-left: 20px;
}

.record-name {
  font-size: 16px;
  color: #333;
  font-weight: 500;
  margin-bottom: 8px;
}

.record-code {
  font-size: 14px;
  color: #999;
}

.record-amount {
  font-size: 16px;
  color: #2f86f6;
  font-weight: 500;
  margin-bottom: 8px;
}

.record-status {
  font-size: 14px;
  color: #999;
}

.empty-wrapper {
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  padding: 80px 0;
}

.empty-text {
  font-size: 14px;
  color: #999;
}

:deep(.van-cell) {
  padding: 20px;
  margin-bottom: 16px;
  border-radius: 12px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
  background-color: #fff;
}

:deep(.van-nav-bar) {
  background-color: #fff;
  border-bottom: 1px solid #f5f5f5;
}

:deep(.van-nav-bar__title) {
  color: #333;
  font-size: 18px;
  font-weight: 600;
}

:deep(.van-nav-bar .van-icon) {
  color: #333;
  font-size: 20px;
}
</style>