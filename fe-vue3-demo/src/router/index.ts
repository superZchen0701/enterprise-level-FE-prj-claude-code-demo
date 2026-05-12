import { createRouter, createWebHistory } from 'vue-router';
import type { RouteRecordRaw } from 'vue-router';

const ExchangeRecord = () => import('../views/ExchangeRecord.vue');

const routes: RouteRecordRaw[] = [
  {
    path: '/exchange-record',
    name: 'ExchangeRecord',
    component: ExchangeRecord,
  },
  {
    path: '/',
    redirect: '/exchange-record',
  },
];

const router = createRouter({
  history: createWebHistory(),
  routes,
});

export default router;