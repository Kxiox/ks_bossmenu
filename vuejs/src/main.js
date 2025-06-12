import './assets/main.css'

import 'bootstrap/scss/bootstrap.scss';
import 'bootstrap-icons/font/bootstrap-icons.css';

import bootstrap from 'bootstrap/dist/js/bootstrap.bundle.js'

import { createApp } from 'vue'
import App from './App.vue'
import { t } from './utils/translation'
import { formatTimestamp } from './utils/timestampFormat'

const app = createApp(App)
app.config.globalProperties.$t = t
app.config.globalProperties.$formatTimestamp = formatTimestamp
app.mount('#app')

