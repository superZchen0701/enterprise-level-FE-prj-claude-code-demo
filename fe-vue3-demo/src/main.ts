import { createApp } from 'vue';
import App from './App.vue';
import { NavBar, Cell, Loading, Toast } from 'vant';
import 'vant/lib/index.css';
import router from './router';

const app = createApp(App);

app.use(NavBar);
app.use(Cell);
app.use(Loading);
app.use(Toast);

app.use(router);

app.mount('#app');