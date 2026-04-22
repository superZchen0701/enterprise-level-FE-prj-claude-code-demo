import Vue from 'vue'
import VueRouter from 'vue-router'
import ExchangeRecord from '../views/ExchangeRecord.vue'

Vue.use(VueRouter)

const routes = [
  {
    path: '/exchange-record',
    name: 'ExchangeRecord',
    component: ExchangeRecord
  },
  {
    path: '/',
    redirect: '/exchange-record'
  }
]

const router = new VueRouter({
  routes
})

export default router