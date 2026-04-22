import Vue from 'vue'
import App from './App.vue'
import router from './router'
import { NavBar, Cell, Loading, Toast } from 'vant'
import 'vant/lib/index.css'

Vue.use(NavBar)
Vue.use(Cell)
Vue.use(Loading)
Vue.use(Toast)

Vue.config.productionTip = false

new Vue({
  router,
  render: h => h(App),
}).$mount('#app')
