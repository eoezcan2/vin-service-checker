<script setup>
import { useRoute, useRouter } from 'vue-router';
import { ref } from 'vue';
import MaintenanceComponent from '../maintenance-component.vue';
import VehiclecardComponent from '../vehiclecard-component.vue';

const route = useRoute();
const router = useRouter();
const vin = ref(route.params.vin);

function goBack() {
    router.go(-1);
}
</script>

<template>
    <div class="service-detail-container">
        <!-- Back Button -->
        <div class="back-button-container">
            <button class="back-btn" @click="goBack" title="Zurück zur Fahrzeugliste">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M19 12H5M12 19l-7-7 7-7"/>
                </svg>
                Zurück
            </button>
        </div>

        <!-- Vehicle Card -->
        <div class="vehicle-section">
            <VehiclecardComponent :vin="vin" />
        </div>

        <!-- Maintenance Section -->
        <div class="maintenance-section">
            <div class="maintenance-container">
                <MaintenanceComponent :vin="vin" />
            </div>
        </div>
    </div>
</template>

<style scoped>
.service-detail-container {
    max-width: 1200px;
    margin: 0 auto;
    padding: 2rem 1rem;
}

.back-button-container {
    margin-bottom: 2rem;
    padding: 0 1rem;
}

.back-btn {
    display: flex;
    align-items: center;
    gap: 0.5rem;
    padding: 0.75rem 1.5rem;
    background: linear-gradient(135deg, #ffffff, #f8f9fa);
    border: 1px solid rgba(0, 0, 0, 0.1);
    border-radius: 8px;
    color: #6c757d;
    font-size: 0.9rem;
    font-weight: 600;
    cursor: pointer;
    transition: all 0.3s ease;
    text-decoration: none;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
}

.back-btn:hover {
    background: #ffffff;
    color: #495057;
    transform: translateY(-2px);
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
}

.vehicle-section {
    margin-bottom: 2rem;
    display: flex;
    justify-content: center;
}

.maintenance-section {
    display: flex;
    justify-content: center;
}

.maintenance-container {
    width: 100%;
    max-width: 800px;
}

/* Responsive Design */
@media (max-width: 768px) {
    .service-detail-container {
        padding: 1rem 0.5rem;
    }
    
    .back-button-container {
        padding: 0 0.5rem;
        margin-bottom: 1.5rem;
    }
    
    .back-btn {
        padding: 0.6rem 1rem;
        font-size: 0.85rem;
    }
}

@media (max-width: 480px) {
    .back-btn {
        width: 100%;
        justify-content: center;
    }
}
</style>