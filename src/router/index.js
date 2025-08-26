import { createWebHistory, createRouter } from 'vue-router'

import HomeView from './../components/views/HomeView.vue'
import ServiceDetailView from './../components/views/ServiceDetailView.vue'
import AboutView from '@/components/views/AboutView.vue'
import LoginView from '@/components/views/LoginView.vue'
import AccountView from '@/components/views/VehiclesView.vue'
import AddVehicleView from "@/components/views/AddVehicleView.vue"
import { isTokenPresent } from '@/api'

const routes = [
    { path: '/', component: HomeView },
    { path: '/about', component: AboutView },
    { path: '/login', component: LoginView},
    { path: '/account', component: AccountView, meta: { requiresAuth: true} },
    { path: '/addvehicle', component: AddVehicleView , meta: { requiresAuth: true} },
    { path: '/vin/:vin', component: ServiceDetailView }
]

const router = createRouter({
  history: createWebHistory(),
  routes,
})

router.beforeEach((to, from, next) => {
  const loggedIn = isTokenPresent

  if (to.meta.requiresAuth && !loggedIn) {
      next('/login')
  } else {
      next()
  }
})

export default router