<script setup>
import axios from 'axios';
import { defineProps, onMounted, ref } from 'vue'

const props = defineProps(['vin'])
let data = ref([])
const loaded = ref(false)
let imgSrc = ref('')

onMounted(() => {
    axios.get(`http://localhost:8080/api/vin/${props.vin}/data`)
        .then(response => {
            console.log(response)
            data.value = response.data
            determineImageSource()
            loaded.value = true
        })
        .catch(error => {
            console.log(error)
        })
})

function determineImageSource() {
    if (data.value.type === 'CAR') {
        imgSrc.value = '/car.svg'
    } else if (data.value.type === 'MOTORCYCLE') {
        imgSrc.value = '/motorcycle.svg'
    }
}

function getVehicleTypeLabel() {
    switch(data.value.type) {
        case 'CAR':
            return 'Auto'
        case 'MOTORCYCLE':
            return 'Motorrad'
        default:
            return data.value.type
    }
}

function getVehicleTypeColor() {
    switch(data.value.type) {
        case 'CAR':
            return 'car-type'
        case 'MOTORCYCLE':
            return 'motorcycle-type'
        default:
            return 'default-type'
    }
}
</script>

<template>
    <div class="vehicle-card-container" v-if="loaded">
        <div class="vehicle-card">
            <!-- Card Header with Icon -->
            <div class="vehicle-header">
                <div class="vehicle-icon-container">
                    <img :src="imgSrc" class="vehicle-icon" :alt="data.type">
                    <div class="vehicle-type-badge" :class="getVehicleTypeColor()">
                        {{ getVehicleTypeLabel() }}
                    </div>
                </div>
            </div>

            <!-- Card Body -->
            <div class="vehicle-body">
                <h3 class="vehicle-name">{{ data.name }}</h3>
                <div class="vehicle-details">
                    <div class="vin-container">
                        <span class="vin-label">VIN:</span>
                        <span class="vin-number">{{ vin }}</span>
                    </div>
                    
                    <!-- Additional vehicle info can be added here -->
                    <div class="vehicle-stats" v-if="data.mileage || data.year">
                        <div class="stat-item" v-if="data.year">
                            <span class="stat-icon">📅</span>
                            <span class="stat-value">{{ data.year }}</span>
                        </div>
                        <div class="stat-item" v-if="data.mileage">
                            <span class="stat-icon">🛣️</span>
                            <span class="stat-value">{{ data.mileage }} km</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Card Footer -->
            <div class="vehicle-footer">
                <div class="vehicle-actions">
                    <button class="action-btn primary-btn" title="Wartung anzeigen">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M14.7 6.3a1 1 0 0 0 0 1.4l1.6 1.6a1 1 0 0 0 1.4 0l3.77-3.77a6 6 0 0 1-7.94 7.94l-6.91 6.91a2.12 2.12 0 0 1-3-3l6.91-6.91a6 6 0 0 1 7.94-7.94l-3.76 3.76z"/>
                        </svg>
                        Wartung
                    </button>
                    <button class="action-btn secondary-btn" title="Details anzeigen">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <circle cx="11" cy="11" r="8"/>
                            <path d="m21 21-4.35-4.35"/>
                        </svg>
                        Details
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Loading State -->
    <div v-else class="vehicle-card-loading">
        <div class="loading-skeleton">
            <div class="skeleton-icon"></div>
            <div class="skeleton-content">
                <div class="skeleton-title"></div>
                <div class="skeleton-text"></div>
            </div>
        </div>
    </div>
</template>

<style scoped>
/* Vehicle Card Container */
.vehicle-card-container {
    width: 100%;
    max-width: 320px;
    margin: 0 auto;
}

/* Main Vehicle Card */
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
    height: 100%;
    display: flex;
    flex-direction: column;
}

.vehicle-card::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    height: 4px;
    background: linear-gradient(90deg, #0d6efd, #0b5ed7, #0a58ca);
}

.vehicle-card:hover {
    transform: translateY(-8px);
    box-shadow: 
        0 20px 40px rgba(0, 0, 0, 0.12),
        0 8px 20px rgba(0, 0, 0, 0.06);
}

/* Vehicle Header */
.vehicle-header {
    padding: 1.5rem 1.5rem 1rem;
    background: linear-gradient(135deg, rgba(13, 110, 253, 0.02), rgba(13, 110, 253, 0.04));
    text-align: center;
}

.vehicle-icon-container {
    position: relative;
    display: inline-block;
}

.vehicle-icon {
    width: 80px;
    height: 80px;
    object-fit: contain;
    filter: drop-shadow(0 4px 8px rgba(0, 0, 0, 0.1));
    transition: transform 0.3s ease;
}

.vehicle-card:hover .vehicle-icon {
    transform: scale(1.05);
}

.vehicle-type-badge {
    position: absolute;
    bottom: -8px;
    left: 50%;
    transform: translateX(-50%);
    padding: 0.25rem 0.75rem;
    border-radius: 999px;
    font-size: 0.75rem;
    font-weight: 600;
    text-transform: uppercase;
    letter-spacing: 0.5px;
    color: #ffffff;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
}

.vehicle-type-badge.car-type {
    background: linear-gradient(135deg, #28a745, #20c997);
}

.vehicle-type-badge.motorcycle-type {
    background: linear-gradient(135deg, #ffc107, #fd7e14);
}

.vehicle-type-badge.default-type {
    background: linear-gradient(135deg, #6f42c1, #e83e8c);
}

/* Vehicle Body */
.vehicle-body {
    padding: 1.5rem;
    flex: 1;
    display: flex;
    flex-direction: column;
}

.vehicle-name {
    color: #212529;
    font-weight: 700;
    font-size: 1.25rem;
    margin: 0 0 1rem 0;
    text-align: center;
    line-height: 1.3;
}

.vehicle-details {
    flex: 1;
}

.vin-container {
    background: rgba(13, 110, 253, 0.05);
    border-radius: 8px;
    padding: 0.75rem;
    margin-bottom: 1rem;
    border: 1px solid rgba(13, 110, 253, 0.1);
}

.vin-label {
    display: block;
    color: #6c757d;
    font-size: 0.8rem;
    font-weight: 600;
    text-transform: uppercase;
    letter-spacing: 0.5px;
    margin-bottom: 0.25rem;
}

.vin-number {
    display: block;
    color: #212529;
    font-family: 'Courier New', monospace;
    font-weight: 600;
    font-size: 0.9rem;
    letter-spacing: 0.5px;
}

.vehicle-stats {
    display: flex;
    gap: 1rem;
    justify-content: center;
    flex-wrap: wrap;
}

.stat-item {
    display: flex;
    align-items: center;
    gap: 0.5rem;
    padding: 0.5rem 0.75rem;
    background: rgba(0, 0, 0, 0.03);
    border-radius: 6px;
    font-size: 0.85rem;
}

.stat-icon {
    font-size: 1rem;
}

.stat-value {
    font-weight: 600;
    color: #495057;
}

/* Vehicle Footer */
.vehicle-footer {
    padding: 1rem 1.5rem 1.5rem;
    border-top: 1px solid rgba(0, 0, 0, 0.06);
    background: rgba(0, 0, 0, 0.02);
}

.vehicle-actions {
    display: flex;
    gap: 0.75rem;
}

.action-btn {
    flex: 1;
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 0.5rem;
    padding: 0.75rem 1rem;
    border: none;
    border-radius: 8px;
    font-size: 0.85rem;
    font-weight: 600;
    cursor: pointer;
    transition: all 0.3s ease;
    text-decoration: none;
}

.primary-btn {
    background: linear-gradient(135deg, #0d6efd, #0b5ed7);
    color: #ffffff;
    box-shadow: 0 4px 12px rgba(13, 110, 253, 0.2);
}

.primary-btn:hover {
    background: linear-gradient(135deg, #0b5ed7, #0a58ca);
    transform: translateY(-2px);
    box-shadow: 0 6px 20px rgba(13, 110, 253, 0.3);
}

.secondary-btn {
    background: rgba(255, 255, 255, 0.8);
    color: #6c757d;
    border: 1px solid rgba(0, 0, 0, 0.1);
}

.secondary-btn:hover {
    background: #ffffff;
    color: #495057;
    transform: translateY(-2px);
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
}

/* Loading State */
.vehicle-card-loading {
    width: 100%;
    max-width: 320px;
    margin: 0 auto;
}

.loading-skeleton {
    background: #ffffff;
    border-radius: 16px;
    padding: 1.5rem;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.06);
    border: 1px solid rgba(0, 0, 0, 0.08);
}

.skeleton-icon {
    width: 80px;
    height: 80px;
    background: linear-gradient(90deg, #f0f0f0 25%, #e0e0e0 50%, #f0f0f0 75%);
    background-size: 200% 100%;
    animation: loading 1.5s infinite;
    border-radius: 50%;
    margin: 0 auto 1rem;
}

.skeleton-content {
    text-align: center;
}

.skeleton-title {
    height: 1.5rem;
    background: linear-gradient(90deg, #f0f0f0 25%, #e0e0e0 50%, #f0f0f0 75%);
    background-size: 200% 100%;
    animation: loading 1.5s infinite;
    border-radius: 4px;
    margin-bottom: 0.75rem;
}

.skeleton-text {
    height: 1rem;
    background: linear-gradient(90deg, #f0f0f0 25%, #e0e0e0 50%, #f0f0f0 75%);
    background-size: 200% 100%;
    animation: loading 1.5s infinite;
    border-radius: 4px;
    width: 80%;
    margin: 0 auto;
}

@keyframes loading {
    0% {
        background-position: 200% 0;
    }
    100% {
        background-position: -200% 0;
    }
}

/* Responsive Design */
@media (max-width: 768px) {
    .vehicle-card-container {
        max-width: 280px;
    }
    
    .vehicle-header {
        padding: 1rem 1rem 0.75rem;
    }
    
    .vehicle-body {
        padding: 1rem;
    }
    
    .vehicle-footer {
        padding: 0.75rem 1rem 1rem;
    }
    
    .vehicle-actions {
        flex-direction: column;
        gap: 0.5rem;
    }
}

@media (max-width: 480px) {
    .vehicle-card-container {
        max-width: 100%;
    }
    
    .vehicle-stats {
        flex-direction: column;
        gap: 0.5rem;
    }
    
    .stat-item {
        justify-content: center;
    }
}
</style>