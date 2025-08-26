<script setup>
import { onMounted, ref, computed, watch } from 'vue';
import MaintenanceComponent from "@/components/maintenance-component.vue";
import {safeRequest} from "@/api";

let data = ref([])
let loaded = ref(false)
let selectedVehicle = ref(null)
let showVehicleSelector = ref(false)

onMounted( () => {
  safeRequest('api/vin/list', 'GET', {})
      .then(response => {
        console.log(response)
        data.value = response.data
        loaded.value = true
        // Auto-select first vehicle if available
        if (data.value.length > 0) {
          selectedVehicle.value = data.value[0]
        }
      }).catch(error => {
        console.log(error)
      })
});

// Computed properties
const selectedVehicleData = computed(() => {
  return selectedVehicle.value
})

const hasVehicles = computed(() => {
  return data.value.length > 0
})

const vehicleCount = computed(() => {
  return data.value.length
})

// Methods
function selectVehicle(vehicle) {
  selectedVehicle.value = vehicle
  showVehicleSelector.value = false
}

// Watch for vehicle selection changes
watch(selectedVehicle, (newVehicle) => {
  if (newVehicle) {
    // Trigger maintenance component to refetch data for new vehicle
    // The MaintenanceComponent will automatically refetch when the vin prop changes
  }
})

function toggleVehicleSelector() {
  showVehicleSelector.value = !showVehicleSelector.value
}


</script>

<template>
  <div class="maintenance-edit-container">
    <!-- Loading State -->
    <div v-if="!loaded" class="loading-container">
      <div class="loading-content">
        <div class="loading-spinner">
          <svg width="40" height="40" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <path d="M21 12a9 9 0 11-6.219-8.56"/>
          </svg>
        </div>
        <p class="loading-text">Lade Fahrzeuge...</p>
      </div>
    </div>

    <!-- Content -->
    <div v-else class="content-container">
      <!-- Header -->
      <div class="page-header">
        <h2 class="page-title">Wartung verwalten</h2>
        <p class="page-subtitle">Verwalten Sie die Wartungshistorie Ihrer Fahrzeuge</p>
      </div>

      <!-- Vehicle Selector -->
      <div v-if="hasVehicles" class="vehicle-selector-section">
        <div class="vehicle-selector">
          <div class="selector-header">
            <h3 class="selector-title">Fahrzeug auswählen</h3>
            <span class="vehicle-count">{{ vehicleCount }} Fahrzeug{{ vehicleCount > 1 ? 'e' : '' }}</span>
          </div>
          
          <!-- Current Vehicle Display -->
          <div class="current-vehicle" @click="toggleVehicleSelector">
            <div class="vehicle-info">
              <div class="vehicle-icon">
                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                  <path d="M19 17h2c.6 0 1-.4 1-1v-3c0-.6-.4-1-1-1h-1l-2-4H7l-2 4H4c-.6 0-1 .4-1 1v3c0 .6.4 1 1 1h2"/>
                  <circle cx="7" cy="18" r="2"/>
                  <circle cx="17" cy="18" r="2"/>
                </svg>
              </div>
              <div class="vehicle-details">
                <h4 class="vehicle-name">{{ selectedVehicleData.name }}</h4>
                <p class="vehicle-vin">{{ selectedVehicleData }}</p>
              </div>
            </div>
            <div class="selector-arrow">
              <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <path d="m6 9 6 6 6-6"/>
              </svg>
            </div>
          </div>

          <!-- Vehicle Dropdown -->
          <div v-if="showVehicleSelector" class="vehicle-dropdown">
            <div 
              v-for="vehicle in data" 
              :key="vehicle"
              class="vehicle-option"
              :class="{ 'selected': vehicle === selectedVehicle }"
              @click="selectVehicle(vehicle)"
            >
              <div class="option-icon">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                  <path d="M19 17h2c.6 0 1-.4 1-1v-3c0-.6-.4-1-1-1h-1l-2-4H7l-2 4H4c-.6 0-1 .4-1 1v3c0 .6.4 1 1 1h2"/>
                  <circle cx="7" cy="18" r="2"/>
                  <circle cx="17" cy="18" r="2"/>
                </svg>
              </div>
              <div class="option-details">
                <span class="option-name">{{ vehicle }}</span>
                <span class="option-vin">{{ vehicle }}</span>
              </div>
              <div v-if="vehicle === selectedVehicle" class="option-check">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                  <path d="M20 6L9 17l-5-5"/>
                </svg>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Maintenance Section -->
      <div v-if="hasVehicles && selectedVehicle" class="maintenance-section">
        <div class="maintenance-content">
          <MaintenanceComponent :vin="selectedVehicle" edit />
        </div>
      </div>

      <!-- Empty State -->
      <div v-if="!hasVehicles" class="empty-state">
        <div class="empty-icon">
          <svg width="80" height="80" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
            <path d="M19 17h2c.6 0 1-.4 1-1v-3c0-.6-.4-1-1-1h-1l-2-4H7l-2 4H4c-.6 0-1 .4-1 1v3c0 .6.4 1 1 1h2"/>
            <circle cx="7" cy="18" r="2"/>
            <circle cx="17" cy="18" r="2"/>
          </svg>
        </div>
        <h3 class="empty-title">Keine Fahrzeuge gefunden</h3>
        <p class="empty-text">Fügen Sie Ihr erstes Fahrzeug hinzu, um mit der Wartungsverwaltung zu beginnen.</p>
        <router-link to="/addvehicle" class="empty-action">
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <line x1="12" y1="5" x2="12" y2="19"/>
            <line x1="5" y1="12" x2="19" y2="12"/>
          </svg>
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
  color: #0d6efd;
  animation: spin 1s linear infinite;
}

@keyframes spin {
  from { transform: rotate(0deg); }
  to { transform: rotate(360deg); }
}

.loading-text {
  color: #6c757d;
  font-weight: 500;
  margin: 1rem 0 0 0;
}

/* Content Container */
.content-container {
  max-width: 1000px;
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

/* Vehicle Selector */
.vehicle-selector-section {
  margin-bottom: 2rem;
  padding: 0 1rem;
}

.vehicle-selector {
  background: #ffffff;
  border-radius: 16px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.06);
  border: 1px solid rgba(0, 0, 0, 0.08);
  overflow: hidden;
  position: relative;
}

.selector-header {
  padding: 1.5rem 1.5rem 0;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.selector-title {
  color: #212529;
  font-weight: 600;
  font-size: 1.1rem;
  margin: 0;
}

.vehicle-count {
  background: linear-gradient(135deg, #0d6efd, #0b5ed7);
  color: #ffffff;
  padding: 0.25rem 0.75rem;
  border-radius: 20px;
  font-size: 0.8rem;
  font-weight: 600;
}

.current-vehicle {
  padding: 1rem 1.5rem;
  display: flex;
  align-items: center;
  justify-content: space-between;
  cursor: pointer;
  transition: all 0.2s ease;
  border-top: 1px solid rgba(0, 0, 0, 0.06);
}

.current-vehicle:hover {
  background: rgba(13, 110, 253, 0.02);
}

.vehicle-info {
  display: flex;
  align-items: center;
  gap: 1rem;
}

.vehicle-icon {
  color: #0d6efd;
  background: rgba(13, 110, 253, 0.1);
  padding: 0.5rem;
  border-radius: 8px;
}

.vehicle-details {
  display: flex;
  flex-direction: column;
}

.vehicle-name {
  color: #212529;
  font-weight: 600;
  font-size: 1rem;
  margin: 0 0 0.25rem 0;
}

.vehicle-vin {
  color: #6c757d;
  font-size: 0.85rem;
  margin: 0;
  font-family: monospace;
}

.selector-arrow {
  color: #6c757d;
  transition: transform 0.2s ease;
}

.vehicle-selector:has(.vehicle-dropdown) .selector-arrow {
  transform: rotate(180deg);
}

/* Vehicle Dropdown */
.vehicle-dropdown {
  border-top: 1px solid rgba(0, 0, 0, 0.06);
  background: #f8f9fa;
  max-height: 300px;
  overflow-y: auto;
}

.vehicle-option {
  padding: 1rem 1.5rem;
  display: flex;
  align-items: center;
  gap: 1rem;
  cursor: pointer;
  transition: all 0.2s ease;
  border-bottom: 1px solid rgba(0, 0, 0, 0.04);
}

.vehicle-option:hover {
  background: rgba(13, 110, 253, 0.05);
}

.vehicle-option.selected {
  background: rgba(13, 110, 253, 0.1);
}

.option-icon {
  color: #0d6efd;
  background: rgba(13, 110, 253, 0.1);
  padding: 0.4rem;
  border-radius: 6px;
}

.option-details {
  flex: 1;
  display: flex;
  flex-direction: column;
}

.option-name {
  color: #212529;
  font-weight: 500;
  font-size: 0.9rem;
}

.option-vin {
  color: #6c757d;
  font-size: 0.8rem;
  font-family: monospace;
}

.option-check {
  color: #0d6efd;
}

/* Maintenance Section */
.maintenance-section {
  background: #ffffff;
  border-radius: 16px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.06);
  border: 1px solid rgba(0, 0, 0, 0.08);
  overflow: hidden;
  margin: 0 1rem;
}

.maintenance-header {
  padding: 1.5rem;
  border-bottom: 1px solid rgba(0, 0, 0, 0.06);
  background: linear-gradient(135deg, rgba(13, 110, 253, 0.02), rgba(13, 110, 253, 0.04));
}

.maintenance-title {
  color: #212529;
  font-weight: 600;
  font-size: 1.25rem;
  margin: 0 0 0.25rem 0;
}

.maintenance-subtitle {
  color: #6c757d;
  font-size: 0.9rem;
  margin: 0;
}

.maintenance-content {
  padding: 1.5rem;
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
  color: #6c757d;
  margin-bottom: 1.5rem;
}

.empty-title {
  color: #212529;
  font-weight: 600;
  font-size: 1.5rem;
  margin: 0 0 1rem 0;
}

.empty-text {
  color: #6c757d;
  font-size: 1rem;
  line-height: 1.6;
  margin: 0 0 2rem 0;
  max-width: 400px;
  margin-left: auto;
  margin-right: auto;
}

.empty-action {
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.75rem 1.5rem;
  background: linear-gradient(135deg, #0d6efd, #0b5ed7);
  color: #ffffff;
  text-decoration: none;
  border-radius: 8px;
  font-weight: 600;
  transition: all 0.3s ease;
  box-shadow: 0 4px 12px rgba(13, 110, 253, 0.3);
}

.empty-action:hover {
  background: linear-gradient(135deg, #0b5ed7, #0a58ca);
  transform: translateY(-2px);
  box-shadow: 0 6px 16px rgba(13, 110, 253, 0.4);
  color: #ffffff;
}

/* Responsive Design */
@media (max-width: 768px) {
  .maintenance-edit-container {
    padding: 1rem 0.5rem;
  }
  
  .page-title {
    font-size: 2rem;
  }
  
  .selector-header {
    flex-direction: column;
    gap: 0.5rem;
    align-items: flex-start;
  }
  
  .vehicle-info {
    gap: 0.75rem;
  }
  
  .vehicle-name {
    font-size: 0.9rem;
  }
  
  .vehicle-vin {
    font-size: 0.8rem;
  }
}

@media (max-width: 480px) {
  .page-title {
    font-size: 1.75rem;
  }
  
  .maintenance-section {
    margin: 0 0.5rem;
  }
  
  .maintenance-header,
  .maintenance-content {
    padding: 1rem;
  }
}
</style>