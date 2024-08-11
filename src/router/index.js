import { createMemoryHistory, createRouter } from 'vue-router'

import HomeView from './../components/views/HomeView.vue'
import ServiceDetailView from './../components/views/ServiceDetailView.vue'

const routes = [
    { path: '/', component: HomeView },
    { path: '/vin/:vin', component: ServiceDetailView }
]

const router = createRouter({
  history: createMemoryHistory(),
  routes,
})

export default router