<script setup>
import { useRoute, useRouter } from 'vue-router';
import { ref, computed, onMounted } from 'vue';
import MaintenanceComponent from '../maintenance-component.vue';
import VehiclecardComponent from '../vehiclecard-component.vue';
import axios from 'axios';

const route = useRoute();
const router = useRouter();
const vin = ref(route.params.vin);
const maintenanceData = ref([]);
const loading = ref(true);

// Computed properties for cost calculations
const totalCost = computed(() => {
    return maintenanceData.value.reduce((sum, item) => sum + (item.cost || 0), 0)
})

const averageCost = computed(() => {
    if (maintenanceData.value.length === 0) return 0
    return totalCost.value / maintenanceData.value.length
})

const costByCategory = computed(() => {
    const categoryCosts = {}
    maintenanceData.value.forEach(item => {
        const category = item.category
        if (!categoryCosts[category]) {
            categoryCosts[category] = 0
        }
        categoryCosts[category] += (item.cost || 0)
    })
    return categoryCosts
})

const mostExpensiveCategory = computed(() => {
    if (Object.keys(costByCategory.value).length === 0) return null
    
    return Object.entries(costByCategory.value).reduce((max, [category, cost]) => {
        return cost > max.cost ? { category, cost } : max
    }, { category: '', cost: 0 })
})

function formatCurrency(amount) {
    return new Intl.NumberFormat('de-DE', {
        style: 'currency',
        currency: 'EUR'
    }).format(amount)
}

function getCategoryDisplayName(category) {
    switch(category) {
        case 'OILCHANGE':
            return 'Ölwechsel'
        case 'TIRECHANGE':
            return 'Reifenwechsel'
        case 'BRAKECHANGE':
            return 'Bremsenwechsel'
        case 'AIRFILTER':
            return 'Luftfilter'
        case 'FUELFILTER':
            return 'Kraftstofffilter'
        case 'SPARKPLUGS':
            return 'Zündkerzen'
        case 'BATTERY':
            return 'Batterie'
        case 'COOLANT':
            return 'Kühlmittel'
        case 'TRANSMISSION':
            return 'Getriebe'
        case 'INSPECTION':
            return 'Inspektion'
        case 'REPAIR':
            return 'Reparatur'
        case 'MISC':
            return 'Sonstiges'
        default:
            return category
    }
}

async function fetchMaintenanceData() {
    try {
        loading.value = true;
        const response = await axios.get(`http://localhost:8080/api/maintenance/${vin.value}`);
        maintenanceData.value = response.data;
    } catch (error) {
        console.error('Error fetching maintenance data:', error);
    } finally {
        loading.value = false;
    }
}

function goBack() {
    router.go(-1);
}

onMounted(() => {
    fetchMaintenanceData();
});
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

        <!-- Cost Summary Section -->
        <div v-if="!loading && maintenanceData.length > 0" class="cost-summary-section">
            <div class="cost-summary-container">
                <div class="cost-summary-header">
                    <h3 class="cost-summary-title">Kostenübersicht</h3>
                    <p class="cost-summary-subtitle">Wartungskosten für dieses Fahrzeug</p>
                </div>
                
                <div class="cost-summary-grid">
                    <div class="cost-summary-card total-cost">
                        <div class="cost-summary-icon">
                            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <circle cx="12" cy="12" r="10"/>
                                <path d="M16 8h-6a2 2 0 1 0 0 4h4a2 2 0 1 1 0 4H8"/>
                                <path d="M12 6v2m0 8v2"/>
                            </svg>
                        </div>
                        <div class="cost-summary-content">
                            <div class="cost-summary-label">Gesamtkosten</div>
                            <div class="cost-summary-value">{{ formatCurrency(totalCost) }}</div>
                            <div class="cost-summary-subvalue">{{ maintenanceData.length }} Wartungen</div>
                        </div>
                    </div>
                    
                    <div class="cost-summary-card average-cost">
                        <div class="cost-summary-icon">
                            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <path d="M8 3H5a2 2 0 0 0-2 2v3m18 0V5a2 2 0 0 0-2-2h-3m0 18h3a2 2 0 0 0 2-2v-3M3 16v3a2 2 0 0 0 2 2h3"/>
                            </svg>
                        </div>
                        <div class="cost-summary-content">
                            <div class="cost-summary-label">Durchschnitt</div>
                            <div class="cost-summary-value">{{ formatCurrency(averageCost) }}</div>
                            <div class="cost-summary-subvalue">pro Wartung</div>
                        </div>
                    </div>
                    
                    <div v-if="mostExpensiveCategory && mostExpensiveCategory.category" class="cost-summary-card expensive-category">
                        <div class="cost-summary-icon">
                            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z"/>
                            </svg>
                        </div>
                        <div class="cost-summary-content">
                            <div class="cost-summary-label">Teuerste Kategorie</div>
                            <div class="cost-summary-value">{{ getCategoryDisplayName(mostExpensiveCategory.category) }}</div>
                            <div class="cost-summary-subvalue">{{ formatCurrency(mostExpensiveCategory.cost) }}</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Maintenance Section -->
        <div class="maintenance-section">
            <div class="maintenance-container">
                <MaintenanceComponent :vin="vin" :showCostSummary="false" />
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

/* Cost Summary Section Styles */
.cost-summary-section {
    margin-bottom: 2rem;
    display: flex;
    justify-content: center;
}

.cost-summary-container {
    width: 100%;
    max-width: 800px;
    padding: 2rem;
    background: linear-gradient(135deg, #ffffff, #f8f9fa);
    border-radius: 16px;
    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
    border: 1px solid rgba(13, 110, 253, 0.08);
}

.cost-summary-header {
    text-align: center;
    margin-bottom: 2rem;
}

.cost-summary-title {
    color: #212529;
    font-weight: 700;
    font-size: 1.75rem;
    margin: 0 0 0.5rem 0;
}

.cost-summary-subtitle {
    color: #6c757d;
    font-size: 1rem;
    margin: 0;
}

.cost-summary-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
    gap: 1.5rem;
}

.cost-summary-card {
    display: flex;
    align-items: center;
    gap: 1rem;
    padding: 1.5rem;
    background: #ffffff;
    border-radius: 10px;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
    border: 1px solid rgba(0, 0, 0, 0.08);
    transition: all 0.3s ease;
}

.cost-summary-card:hover {
    transform: translateY(-2px);
    box-shadow: 0 4px 16px rgba(0, 0, 0, 0.1);
}

.cost-summary-icon {
    display: flex;
    align-items: center;
    justify-content: center;
    width: 48px;
    height: 48px;
    border-radius: 12px;
    flex-shrink: 0;
}

.total-cost .cost-summary-icon {
    background: linear-gradient(135deg, #28a745, #20c997);
    color: #ffffff;
}

.average-cost .cost-summary-icon {
    background: linear-gradient(135deg, #17a2b8, #6f42c1);
    color: #ffffff;
}

.expensive-category .cost-summary-icon {
    background: linear-gradient(135deg, #ffc107, #fd7e14);
    color: #ffffff;
}

.cost-summary-content {
    flex: 1;
    min-width: 0;
}

.cost-summary-label {
    color: #6c757d;
    font-size: 0.85rem;
    font-weight: 600;
    text-transform: uppercase;
    letter-spacing: 0.5px;
    margin-bottom: 0.25rem;
}

.cost-summary-value {
    color: #212529;
    font-size: 1.5rem;
    font-weight: 700;
    line-height: 1.2;
    margin-bottom: 0.25rem;
}

.cost-summary-subvalue {
    color: #6c757d;
    font-size: 0.9rem;
    font-weight: 500;
}

/* Responsive Cost Summary */
@media (max-width: 768px) {
    .cost-summary-container {
        padding: 1.5rem;
        margin: 0 1rem;
    }
    
    .cost-summary-grid {
        grid-template-columns: 1fr;
        gap: 1rem;
    }
    
    .cost-summary-card {
        padding: 1.25rem;
    }
    
    .cost-summary-icon {
        width: 40px;
        height: 40px;
    }
    
    .cost-summary-value {
        font-size: 1.25rem;
    }
}

@media (max-width: 480px) {
    .cost-summary-container {
        padding: 1rem;
        margin: 0 0.5rem;
    }
    
    .cost-summary-card {
        flex-direction: column;
        text-align: center;
        gap: 0.75rem;
    }
    
    .cost-summary-icon {
        width: 36px;
        height: 36px;
    }
    
    .cost-summary-value {
        font-size: 1.1rem;
    }
}
</style>