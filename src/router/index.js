import { createWebHistory, createRouter } from 'vue-router'

import HomeView from './../components/views/HomeView.vue'
import ServiceDetailView from './../components/views/ServiceDetailView.vue'
import AboutView from '@/components/views/AboutView.vue'
import LoginView from '@/components/views/LoginView.vue'
import AccountView from '@/components/views/AccountView.vue'

const routes = [
    { path: '/', component: HomeView },
    { path: '/about', component: AboutView },
    { path: '/login', component: LoginView},
    { path: '/account', component: AccountView },
    { path: '/vin/:vin', component: ServiceDetailView }
]

const router = createRouter({
  history: createWebHistory(),
  routes,
})

export default router