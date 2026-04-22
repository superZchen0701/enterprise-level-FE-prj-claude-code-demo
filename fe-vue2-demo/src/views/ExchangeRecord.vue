<template>
  <div class="exchange-record">
    <van-nav-bar title="兑换记录" left-arrow @click-left="onClickLeft" />
    <div class="record-list">
      <div v-if="loading" class="loading-wrapper">
        <van-loading size="24px" vertical>加载中...</van-loading>
      </div>
      <van-cell v-else v-for="item in records" :key="item.code">
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
    </div>
  </div>
</template>

<script>
import { getExchangeRecords } from '@/api/exchange.js'

export default {
  name: 'ExchangeRecord',
  data() {
    return {
      records: [],
      loading: false
    }
  },
  created() {
    this.fetchRecords()
  },
  methods: {
    // 获取兑换记录列表
    fetchRecords() {
      this.loading = true
      getExchangeRecords()
        .then(data => {
          this.records = data
        })
        .catch(err => {
          this.$toast(err.message || '获取数据失败')
        })
        .finally(() => {
          this.loading = false
        })
    },
    onClickLeft() {
      // 判断是否有历史记录
      if (window.history.length > 1) {
        this.$router.back()
      } else {
        this.$toast('当前页面无法返回上一页')
      }
    }
  }
}
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