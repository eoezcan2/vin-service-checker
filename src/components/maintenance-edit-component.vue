<script setup>
import { onMounted, ref } from 'vue';
import MaintenanceComponent from "@/components/maintenance-component.vue";
import VehiclecardComponent from "@/components/vehiclecard-component.vue";
import {safeRequest} from "@/api";

let data = ref([])
let loaded = ref(false)

onMounted( () => {
  safeRequest('api/vin/list', 'GET', {})
      .then(response => {
        console.log(response)
        data.value = response.data
        loaded.value = true
      }).catch(error => {
        console.log(error)
      })
});
</script>

<template>
  <div class="maintenance-edit-container">
    <!-- Loading State -->
    <div v-if="!loaded" class="loading-container">
      <div class="loading-content">
        <div class="spinner-border text-primary loading-spinner" role="status" aria-hidden="true"></div>
        <p class="loading-text mt-3">Lade Fahrzeuge...</p>
      </div>
    </div>

    <!-- Content -->
    <div v-else class="content-container">
      <!-- Header -->
      <div class="page-header">
        <h2 class="page-title">Wartung bearbeiten</h2>
        <p class="page-subtitle">Verwalten Sie die Wartungshistorie Ihrer Fahrzeuge</p>
      </div>

      <!-- Vehicles Grid -->
      <div class="vehicles-grid">
        <div v-for="(vin, idx) in data" :key="idx" class="vehicle-card">
          <div class="vehicle-header">
            <VehiclecardComponent :vin="vin" class="vehicle-info"/>
          </div>
          <div class="maintenance-section">
            <MaintenanceComponent :vin="vin" edit class="maintenance-content"/>
          </div>
        </div>
      </div>

      <!-- Empty State -->
      <div v-if="data.length === 0" class="empty-state">
        <div class="empty-icon">🚗</div>
        <h3 class="empty-title">Keine Fahrzeuge gefunden</h3>
        <p class="empty-text">Fügen Sie Ihr erstes Fahrzeug hinzu, um mit der Wartungsverwaltung zu beginnen.</p>
        <router-link to="/add-vehicle" class="btn btn-primary empty-action">
          Fahrzeug hinzufügen
        </router-link>
      </div>
    </div>
  </div>
</template>

<style scoped>
/* Main Container */
.maintenance-edit-container {
  min-height: calc(100vh - 100px);
  background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
  padding: 2rem 1rem;
}

/* Loading State */
.loading-container {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 400px;
}

.loading-content {
  text-align: center;
}

.loading-spinner {
  width: 3rem;
  height: 3rem;
  border-width: 0.25rem;
}

.loading-text {
  color: #6c757d;
  font-weight: 500;
  margin: 0;
}

/* Content Container */
.content-container {
  max-width: 1200px;
  margin: 0 auto;
}

/* Page Header */
.page-header {
  text-align: center;
  margin-bottom: 3rem;
  padding: 0 1rem;
}

.page-title {
  color: #212529;
  font-weight: 700;
  font-size: 2.5rem;
  margin-bottom: 0.5rem;
  background: linear-gradient(135deg, #0d6efd, #0b5ed7);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.page-subtitle {
  color: #6c757d;
  font-size: 1.1rem;
  margin: 0;
  font-weight: 400;
}

/* Vehicles Grid */
.vehicles-grid {
  display: grid;
  gap: 2rem;
  grid-template-columns: repeat(auto-fit, minmax(400px, 1fr));
  padding: 0 1rem;
}

/* Vehicle Card */
.vehicle-card {
  background: linear-gradient(145deg, #ffffff, #f8f9fa);
  border-radius: 16px;
  box-shadow: 
    0 10px 30px rgba(0, 0, 0, 0.08),
    0 4px 12px rgba(0, 0, 0, 0.04);
  border: 1px solid rgba(13, 110, 253, 0.08);
  overflow: hidden;
  transition: all 0.3s ease;
  position: relative;
}

.vehicle-card::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 4px;
}

/*.vehicle-card:hover {
  transform: translateY(-8px);
  box-shadow: 
    0 20px 40px rgba(0, 0, 0, 0.12),
    0 8px 20px rgba(0, 0, 0, 0.06);
}*/

.vehicle-header {
  padding: 1.5rem 1.5rem 0;
  background: linear-gradient(135deg, rgba(13, 110, 253, 0.02), rgba(13, 110, 253, 0.04));
}

.vehicle-info {
  margin-bottom: 0;
}

.maintenance-section {
  padding: 1.5rem;
}

.maintenance-content {
  background: #ffffff;
  border-radius: 12px;
  padding: 1rem;
  border: 1px solid rgba(0, 0, 0, 0.06);
}

/* Empty State */
.empty-state {
  text-align: center;
  padding: 4rem 2rem;
  background: linear-gradient(145deg, #ffffff, #f8f9fa);
  border-radius: 16px;
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
  border: 1px solid rgba(13, 110, 253, 0.08);
  margin: 2rem 1rem;
}

.empty-icon {
  font-size: 4rem;
  margin-bottom: 1rem;
}

.empty-title {
  color: #212529;
  font-weight: 600;
  margin-bottom: 0.5rem;
}

.empty-text {
  color: #6c757d;
  margin-bottom: 2rem;
  font-size: 1.1rem;
}

.empty-action {
  padding: 0.75rem 2rem;
  border-radius: 999px;
  font-weight: 600;
  box-shadow: 0 6px 18px rgba(13, 110, 253, 0.15);
  transition: all 0.3s ease;
}

.empty-action:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 25px rgba(13, 110, 253, 0.2);
}

/* Responsive Design */
@media (max-width: 768px) {
  .maintenance-edit-container {
    padding: 1rem 0.5rem;
  }
  
  .page-title {
    font-size: 2rem;
  }
  
  .page-subtitle {
    font-size: 1rem;
  }
  
  .vehicles-grid {
    grid-template-columns: 1fr;
    gap: 1.5rem;
    padding: 0 0.5rem;
  }
  
  .vehicle-card {
    border-radius: 12px;
  }
  
  .vehicle-header,
  .maintenance-section {
    padding: 1rem;
  }
  
  .empty-state {
    padding: 3rem 1rem;
    margin: 1rem 0.5rem;
  }
  
  .empty-icon {
    font-size: 3rem;
  }
}

@media (max-width: 480px) {
  .page-title {
    font-size: 1.75rem;
  }
  
  .vehicle-card {
    border-radius: 8px;
  }
  
  .vehicle-header,
  .maintenance-section {
    padding: 0.75rem;
  }
}
</style>