import { createWebHistory, createRouter } from 'vue-router'

import HomeView from './../components/views/HomeView.vue'
import ServiceDetailView from './../components/views/ServiceDetailView.vue'
import AboutView from '@/components/views/AboutView.vue'
import LoginView from '@/components/views/LoginView.vue'
import AccountView from '@/components/views/VehiclesView.vue'
import AddVehicleView from "@/components/views/AddVehicleView.vue"
import { isTokenPresent } from '@/api'

const routes = [
    { 
        path: '/', 
        name: 'home',
        component: HomeView,
        meta: { title: 'VIN Service Checker - Fahrzeug Service Verwaltung' }
    },
    { 
        path: '/about', 
        name: 'about',
        component: AboutView,
        meta: { title: 'Über uns - VIN Service Checker' }
    },
    { 
        path: '/login', 
        name: 'login',
        component: LoginView,
        meta: { title: 'Anmelden - VIN Service Checker' }
    },
    { 
        path: '/account', 
        name: 'account',
        component: AccountView, 
        meta: { 
            requiresAuth: true,
            title: 'Fahrzeuge verwalten - VIN Service Checker'
        }
    },
    { 
        path: '/addvehicle', 
        name: 'add-vehicle',
        component: AddVehicleView,
        meta: { 
            requiresAuth: true,
            title: 'Fahrzeug hinzufügen - VIN Service Checker'
        }
    },
    { 
        path: '/vin/:vin', 
        name: 'vin-detail',
        component: ServiceDetailView,
        meta: { 
            title: 'Service Details - VIN Service Checker'
        }
    }
]

const router = createRouter({
  history: createWebHistory(),
  routes,
})

router.beforeEach((to, from, next) => {
  const loggedIn = isTokenPresent.value

  if (to.meta.requiresAuth && !loggedIn) {
      next('/login')
  } else {
      next()
  }
})

router.afterEach((to) => {
  // Set page title based on route
  let pageTitle = 'VIN Service Checker - Fahrzeug Service Verwaltung'
  
  if (to.meta.title) {
    pageTitle = to.meta.title
    
    // Handle dynamic titles with route parameters
    if (to.name === 'vin-detail' && to.params.vin) {
      pageTitle = `VIN ${to.params.vin} - Service Details - VIN Service Checker`
    }
  }
  
  document.title = pageTitle
  
  // Scroll to top on every route change
  window.scrollTo({ top: 0, behavior: 'smooth' })
})

export default router