<script setup>
import axios from 'axios';
import { ref, defineProps, onMounted, watch, computed } from 'vue';
import { safeRequest } from '@/api';

const categories = [
    'OILCHANGE', 
    'TIRECHANGE', 
    'BRAKECHANGE', 
    'AIRFILTER', 
    'FUELFILTER', 
    'SPARKPLUGS', 
    'BATTERY', 
    'COOLANT', 
    'TRANSMISSION', 
    'INSPECTION', 
    'REPAIR', 
    'MISC'
]

const props = defineProps({
    vin: String,
    edit: Boolean,
    showCostSummary: {
        type: Boolean,
        default: true
    }
})

let data = ref([])

let newDate = ref('')
let newCategory = ref('')
let newDescription = ref('')
let newMileage = ref('')
let newCost = ref('')

// Custom confirmation dialog
let showConfirmDialog = ref(false)
let itemToDelete = ref(null)

// Computed properties for cost calculations
const totalCost = computed(() => {
    return data.value.reduce((sum, item) => sum + (item.cost || 0), 0)
})

const averageCost = computed(() => {
    if (data.value.length === 0) return 0
    return totalCost.value / data.value.length
})

const costByCategory = computed(() => {
    const categoryCosts = {}
    data.value.forEach(item => {
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

function clearInputs() {
    newDate.value = ''
    newCategory.value = ''
    newDescription.value = ''
    newMileage.value = ''
    newCost.value = ''
}

function getMaintenances() {
    axios.get(`http://localhost:8080/api/maintenance/${props.vin}`)
        .then(response => {
            data.value = response.data
        })
        .catch(() => {
            // Handle error silently or show user-friendly message
        })
}

function addMaintenance() {
    safeRequest('api/maintenance', 'POST', {
        vin: props.vin,
        date: newDate.value,
        category: categories.findIndex(category => category === newCategory.value),
        description: newDescription.value,
        mileage: newMileage.value,
        cost: newCost.value
    }).then(() => {
        getMaintenances()
    }).catch(() => {
        // Handle error silently or show user-friendly message
    })
    clearInputs()
}

function showDeleteConfirmation(id) {
  itemToDelete.value = id
  showConfirmDialog.value = true
}

function confirmDelete() {
  if (itemToDelete.value) {
    safeRequest(`api/maintenance/${itemToDelete.value}`, 'DELETE', {})
      .then(() => {
          getMaintenances()
      }).catch(() => {
          // Handle error silently or show user-friendly message
      })
  }
  closeConfirmDialog()
}

function closeConfirmDialog() {
  showConfirmDialog.value = false
  itemToDelete.value = null
}

function convertDate(date) {
    // date string looks like this: 2021-10-10T00:00:00.000+00:00
    return new Date(date).toLocaleDateString()
}

function getCategoryClass(category) {
    switch(category.toLowerCase()) {
        case 'oilchange':
            return 'oilchange'
        case 'tirechange':
            return 'tirechange'
        case 'brakechange':
            return 'brakechange'
        case 'airfilter':
            return 'airfilter'
        case 'fuelfilter':
            return 'fuelfilter'
        case 'sparkplugs':
            return 'sparkplugs'
        case 'battery':
            return 'battery'
        case 'coolant':
            return 'coolant'
        case 'transmission':
            return 'transmission'
        case 'inspection':
            return 'inspection'
        case 'repair':
            return 'repair'
        case 'misc':
            return 'misc'
        default:
            return 'misc'
    }
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

function formatCurrency(amount) {
    return new Intl.NumberFormat('de-DE', {
        style: 'currency',
        currency: 'EUR'
    }).format(amount)
}

onMounted(() => {
    getMaintenances()
})

// Watch for vin prop changes to refetch data
watch(() => props.vin, (newVin) => {
    if (newVin) {
        getMaintenances()
    }
})
</script>

<template>
    <div class="maintenance-table-container">
        <!-- Table Header -->
        <div class="table-header">
            <h4 class="table-title text-center">Wartungshistorie</h4>
            <p class="table-subtitle text-center" v-if="data.length > 0">{{ data.length }} Einträge gefunden</p>
            <p class="table-subtitle text-center" v-else>Keine Wartungseinträge vorhanden</p>
        </div>

        <!-- Cost Summary Section -->
        <div v-if="data.length > 0 && props.showCostSummary" class="cost-summary">
            <div class="cost-summary-grid">
                <div class="cost-card total-cost">
                    <div class="cost-icon">
                        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <circle cx="12" cy="12" r="10"/>
                            <path d="M16 8h-6a2 2 0 1 0 0 4h4a2 2 0 1 1 0 4H8"/>
                            <path d="M12 6v2m0 8v2"/>
                        </svg>
                    </div>
                    <div class="cost-content">
                        <div class="cost-label">Gesamtkosten</div>
                        <div class="cost-value">{{ formatCurrency(totalCost) }}</div>
                    </div>
                </div>
                
                <div class="cost-card average-cost">
                    <div class="cost-icon">
                        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M8 3H5a2 2 0 0 0-2 2v3m18 0V5a2 2 0 0 0-2-2h-3m0 18h3a2 2 0 0 0 2-2v-3M3 16v3a2 2 0 0 0 2 2h3"/>
                        </svg>
                    </div>
                    <div class="cost-content">
                        <div class="cost-label">Durchschnitt</div>
                        <div class="cost-value">{{ formatCurrency(averageCost) }}</div>
                    </div>
                </div>
                
                <div v-if="mostExpensiveCategory && mostExpensiveCategory.category" class="cost-card expensive-category">
                    <div class="cost-icon">
                        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z"/>
                        </svg>
                    </div>
                    <div class="cost-content">
                        <div class="cost-label">Teuerste Kategorie</div>
                        <div class="cost-value">{{ getCategoryDisplayName(mostExpensiveCategory.category) }}</div>
                        <div class="cost-subvalue">{{ formatCurrency(mostExpensiveCategory.cost) }}</div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Table -->
        <div class="table-wrapper">
            <table class="maintenance-table">
                <thead>
                    <tr>
                        <th style="text-align: left;">Datum</th>
                        <th style="text-align: center;">Art</th>
                        <th style="text-align: left;">Notiz</th>
                        <th style="text-align: right;">Kilometerstand</th>
                        <th style="text-align: right;">Kosten</th>
                        <th v-if="props.edit" class="action-header"></th>
                    </tr>
                </thead>
                <tbody>
                    <tr v-for="item in data" :key="item.id" class="table-row">
                        <td class="date-cell">{{ convertDate(item.date) }}</td>
                        <td class="category-cell">
                            <span class="category-badge" :class="getCategoryClass(item.category)">
                                {{ item.category }}
                            </span>
                        </td>
                        <td class="description-cell">{{ item.description || '-' }}</td>
                        <td class="mileage-cell">{{ item.mileage }} km</td>
                        <td class="cost-cell">{{ item.cost }}€</td>
                        <td v-if="props.edit" class="action-cell">
                            <button class="delete-btn" @click="showDeleteConfirmation(item.id)" title="Löschen">
                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <path d="M3 6h18M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/>
                                </svg>
                            </button>
                        </td>
                    </tr>
                    
                    <!-- Add New Entry Row -->
                    <tr v-if="props.edit" class="add-row">
                        <td>
                            <input type="date" class="form-input" v-model="newDate" placeholder="Datum">
                        </td>
                        <td>
                            <select v-model="newCategory" class="form-select">
                                <option value="" disabled>Art wählen</option>
                                <option v-for="category in categories" :key="category" :value="category">
                                    {{ getCategoryDisplayName(category) }}
                                </option>
                            </select>
                        </td>
                        <td>
                            <input type="text" class="form-input" v-model="newDescription" placeholder="Notiz">
                        </td>
                        <td>
                            <input type="number" class="form-input" v-model="newMileage" placeholder="km">
                        </td>
                        <td>
                            <input type="number" class="form-input" v-model="newCost" placeholder="€">
                        </td>
                        <td>
                            <button class="add-btn" @click="addMaintenance" title="Hinzufügen">
                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <line x1="12" y1="5" x2="12" y2="19"/>
                                    <line x1="5" y1="12" x2="19" y2="12"/>
                                </svg>
                            </button>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>

        <!-- Empty State -->
        <div v-if="data.length === 0 && !props.edit" class="empty-table">
            <div class="empty-icon">🔧</div>
            <p class="empty-text">Noch keine Wartungseinträge vorhanden</p>
        </div>
    </div>

    <!-- Custom Confirmation Dialog -->
    <div v-if="showConfirmDialog" class="modal-overlay" @click="closeConfirmDialog">
        <div class="modal-content" @click.stop>
            <div class="modal-header">
                <div class="modal-icon">
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/>
                        <line x1="12" y1="9" x2="12" y2="13"/>
                        <line x1="12" y1="17" x2="12.01" y2="17"/>
                    </svg>
                </div>
                <h3 class="modal-title">Wartungseintrag löschen</h3>
            </div>
            <div class="modal-body">
                <p class="modal-message">
                    Sind Sie sicher, dass Sie diesen Wartungseintrag löschen möchten? 
                    Diese Aktion kann nicht rückgängig gemacht werden.
                </p>
            </div>
            <div class="modal-footer">
                <button class="modal-btn modal-btn-cancel" @click="closeConfirmDialog">
                    Abbrechen
                </button>
                <button class="modal-btn modal-btn-delete" @click="confirmDelete">
                    Löschen
                </button>
            </div>
        </div>
    </div>
</template>

<style scoped>
/* Container */
.maintenance-table-container {
    width: 100%;
}

/* Table Header */
.table-header {
    margin-bottom: 1.5rem;
    text-align: center;
}

.table-title {
    color: #212529;
    font-weight: 600;
    font-size: 1.25rem;
    margin: 0 0 0.25rem 0;
}

.table-subtitle {
    color: #6c757d;
    font-size: 0.9rem;
    margin: 0;
    font-weight: 400;
}

/* Table Wrapper */
.table-wrapper {
    background: #ffffff;
    border-radius: 12px;
    overflow: hidden;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
    border: 1px solid rgba(0, 0, 0, 0.08);
}

/* Table */
.maintenance-table {
    width: 100%;
    border-collapse: collapse;
    font-size: 0.9rem;
}

/* Header */
.maintenance-table thead {
    background: linear-gradient(135deg, #0d6efd, #0b5ed7);
}

.maintenance-table th {
    color: #ffffff;
    font-weight: 600;
    padding: 1rem 0.75rem;
    text-align: left;
    font-size: 0.85rem;
    text-transform: uppercase;
    letter-spacing: 0.5px;
    border: none;
    vertical-align: middle;
}

.action-header {
    width: 60px;
    text-align: center;
}

/* Rows */
.table-row {
    border-bottom: 1px solid rgba(0, 0, 0, 0.06);
    transition: background-color 0.2s ease;
}

.table-row:hover {
    background-color: rgba(13, 110, 253, 0.02);
}

.table-row:last-child {
    border-bottom: none;
}

.maintenance-table td {
    padding: 1rem 0.75rem;
    vertical-align: middle;
    border: none;
}

/* Cell Types */
.date-cell {
    font-weight: 500;
    color: #495057;
    white-space: nowrap;
    text-align: left;
}

.category-cell {
    text-align: center;
}

.description-cell {
    max-width: 200px;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
    text-align: left;
}

.mileage-cell, .cost-cell {
    text-align: right;
    font-weight: 500;
    color: #495057;
}

.action-cell {
    text-align: center;
    width: 60px;
}

/* Category Badges */
.category-badge {
    display: inline-block;
    padding: 0.25rem 0.75rem;
    border-radius: 999px;
    font-size: 0.75rem;
    font-weight: 600;
    text-transform: uppercase;
    letter-spacing: 0.5px;
}

.category-badge.oilchange {
    background: linear-gradient(135deg, #28a745, #20c997);
    color: #ffffff;
}

.category-badge.tirechange {
    background: linear-gradient(135deg, #ffc107, #fd7e14);
    color: #ffffff;
}

.category-badge.brakechange {
    background: linear-gradient(135deg, #dc3545, #c82333);
    color: #ffffff;
}

.category-badge.airfilter {
    background: linear-gradient(135deg, #17a2b8, #138496);
    color: #ffffff;
}

.category-badge.fuelfilter {
    background: linear-gradient(135deg, #6f42c1, #5a32a3);
    color: #ffffff;
}

.category-badge.sparkplugs {
    background: linear-gradient(135deg, #fd7e14, #e55a00);
    color: #ffffff;
}

.category-badge.battery {
    background: linear-gradient(135deg, #20c997, #17a2b8);
    color: #ffffff;
}

.category-badge.coolant {
    background: linear-gradient(135deg, #0dcaf0, #0aa2c0);
    color: #ffffff;
}

.category-badge.transmission {
    background: linear-gradient(135deg, #6c757d, #5a6268);
    color: #ffffff;
}

.category-badge.inspection {
    background: linear-gradient(135deg, #198754, #146c43);
    color: #ffffff;
}

.category-badge.repair {
    background: linear-gradient(135deg, #e83e8c, #d63384);
    color: #ffffff;
}

.category-badge.misc {
    background: linear-gradient(135deg, #6f42c1, #e83e8c);
    color: #ffffff;
}

/* Action Buttons */
.delete-btn, .add-btn {
    width: 32px;
    height: 32px;
    border: none;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    cursor: pointer;
    transition: all 0.2s ease;
    color: #ffffff;
}

.delete-btn {
    background: linear-gradient(135deg, #dc3545, #c82333);
}

.delete-btn:hover {
    background: linear-gradient(135deg, #c82333, #bd2130);
    transform: scale(1.05);
}

.add-btn {
    background: linear-gradient(135deg, #28a745, #20c997);
}

.add-btn:hover {
    background: linear-gradient(135deg, #20c997, #17a2b8);
    transform: scale(1.05);
}

/* Add Row */
.add-row {
    background: linear-gradient(135deg, rgba(13, 110, 253, 0.02), rgba(13, 110, 253, 0.04));
    border-top: 2px solid rgba(13, 110, 253, 0.1);
}

.add-row td {
    padding: 0.75rem;
}

/* Form Controls */
.form-input, .form-select {
    width: 100%;
    padding: 0.5rem 0.75rem;
    border: 1px solid rgba(0, 0, 0, 0.1);
    border-radius: 6px;
    font-size: 0.85rem;
    background: #ffffff;
    transition: all 0.2s ease;
    font-family: inherit;
}

.form-input:focus, .form-select:focus {
    outline: none;
    border-color: #0d6efd;
    box-shadow: 0 0 0 3px rgba(13, 110, 253, 0.1);
}

.form-input::placeholder {
    color: #adb5bd;
}

.form-select {
    cursor: pointer;
    background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16'%3e%3cpath fill='none' stroke='%23343a40' stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='m1 6 7 7 7-7'/%3e%3c/svg%3e");
    background-repeat: no-repeat;
    background-position: right 0.75rem center;
    background-size: 16px 12px;
    padding-right: 2.5rem;
    appearance: none;
}

.form-select:focus {
    background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16'%3e%3cpath fill='none' stroke='%230d6efd' stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='m1 6 7 7 7-7'/%3e%3c/svg%3e");
}

/* Empty State */
.empty-table {
    text-align: center;
    padding: 3rem 1rem;
    color: #6c757d;
}

.empty-icon {
    font-size: 3rem;
    margin-bottom: 1rem;
}

.empty-text {
    margin: 0;
    font-size: 1rem;
}

/* Responsive Design */
@media (max-width: 768px) {
    .maintenance-table {
        font-size: 0.8rem;
    }
    
    .maintenance-table th,
    .maintenance-table td {
        padding: 0.75rem 0.5rem;
    }
    
    .description-cell {
        max-width: 120px;
    }
    
    .category-badge {
        padding: 0.2rem 0.5rem;
        font-size: 0.7rem;
    }
    
    .delete-btn, .add-btn {
        width: 28px;
        height: 28px;
    }
}

@media (max-width: 480px) {
    .table-title {
        font-size: 1.1rem;
    }
    
    .maintenance-table th,
    .maintenance-table td {
        padding: 0.5rem 0.25rem;
    }
    
    .description-cell {
        max-width: 80px;
    }
}

/* Custom Modal Dialog */
.modal-overlay {
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: rgba(0, 0, 0, 0.5);
    display: flex;
    align-items: center;
    justify-content: center;
    z-index: 1000;
    backdrop-filter: blur(4px);
}

.modal-content {
    background: #ffffff;
    border-radius: 12px;
    box-shadow: 0 20px 40px rgba(0, 0, 0, 0.15);
    max-width: 400px;
    width: 90%;
    margin: 1rem;
    overflow: hidden;
    animation: modalSlideIn 0.3s ease-out;
}

@keyframes modalSlideIn {
    from {
        opacity: 0;
        transform: translateY(-20px) scale(0.95);
    }
    to {
        opacity: 1;
        transform: translateY(0) scale(1);
    }
}

.modal-header {
    padding: 1.5rem 1.5rem 0 1.5rem;
    text-align: center;
}

.modal-icon {
    color: #dc3545;
    margin-bottom: 1rem;
}

.modal-title {
    color: #212529;
    font-weight: 600;
    font-size: 1.25rem;
    margin: 0;
}

.modal-body {
    padding: 1rem 1.5rem;
}

.modal-message {
    color: #6c757d;
    line-height: 1.6;
    margin: 0;
    text-align: center;
}

.modal-footer {
    padding: 0 1.5rem 1.5rem 1.5rem;
    display: flex;
    gap: 0.75rem;
    justify-content: center;
}

.modal-btn {
    padding: 0.75rem 1.5rem;
    border: none;
    border-radius: 8px;
    font-weight: 600;
    font-size: 0.9rem;
    cursor: pointer;
    transition: all 0.2s ease;
    min-width: 100px;
}

.modal-btn-cancel {
    background: #f8f9fa;
    color: #6c757d;
    border: 1px solid #dee2e6;
}

.modal-btn-cancel:hover {
    background: #e9ecef;
    color: #495057;
}

.modal-btn-delete {
    background: linear-gradient(135deg, #dc3545, #c82333);
    color: #ffffff;
    box-shadow: 0 4px 12px rgba(220, 53, 69, 0.3);
}

.modal-btn-delete:hover {
    background: linear-gradient(135deg, #c82333, #bd2130);
    transform: translateY(-1px);
    box-shadow: 0 6px 16px rgba(220, 53, 69, 0.4);
}

.modal-btn-delete:active {
    transform: translateY(0);
}

/* Responsive Modal */
@media (max-width: 480px) {
    .modal-content {
        margin: 0.5rem;
        width: calc(100% - 1rem);
    }
    
    .modal-header,
    .modal-body,
    .modal-footer {
        padding-left: 1rem;
        padding-right: 1rem;
    }
    
    .modal-footer {
        flex-direction: column;
    }
    
    .modal-btn {
        width: 100%;
    }
}

/* Cost Summary Styles */
.cost-summary {
    margin-bottom: 2rem;
    padding: 1.5rem;
    background: linear-gradient(135deg, #ffffff, #f8f9fa);
    border-radius: 12px;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
    border: 1px solid rgba(0, 0, 0, 0.08);
}

.cost-summary-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
    gap: 1.5rem;
}

.cost-card {
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

.cost-card:hover {
    transform: translateY(-2px);
    box-shadow: 0 4px 16px rgba(0, 0, 0, 0.1);
}

.cost-icon {
    display: flex;
    align-items: center;
    justify-content: center;
    width: 48px;
    height: 48px;
    border-radius: 12px;
    flex-shrink: 0;
}

.total-cost .cost-icon {
    background: linear-gradient(135deg, #28a745, #20c997);
    color: #ffffff;
}

.average-cost .cost-icon {
    background: linear-gradient(135deg, #17a2b8, #6f42c1);
    color: #ffffff;
}

.expensive-category .cost-icon {
    background: linear-gradient(135deg, #ffc107, #fd7e14);
    color: #ffffff;
}

.cost-content {
    flex: 1;
    min-width: 0;
}

.cost-label {
    color: #6c757d;
    font-size: 0.85rem;
    font-weight: 600;
    text-transform: uppercase;
    letter-spacing: 0.5px;
    margin-bottom: 0.25rem;
}

.cost-value {
    color: #212529;
    font-size: 1.5rem;
    font-weight: 700;
    line-height: 1.2;
    margin-bottom: 0.25rem;
}

.cost-subvalue {
    color: #6c757d;
    font-size: 0.9rem;
    font-weight: 500;
}

/* Responsive Cost Summary */
@media (max-width: 768px) {
    .cost-summary {
        padding: 1rem;
        margin-bottom: 1.5rem;
    }
    
    .cost-summary-grid {
        grid-template-columns: 1fr;
        gap: 1rem;
    }
    
    .cost-card {
        padding: 1rem;
    }
    
    .cost-icon {
        width: 40px;
        height: 40px;
    }
    
    .cost-value {
        font-size: 1.25rem;
    }
}

@media (max-width: 480px) {
    .cost-card {
        flex-direction: column;
        text-align: center;
        gap: 0.75rem;
    }
    
    .cost-icon {
        width: 36px;
        height: 36px;
    }
    
    .cost-value {
        font-size: 1.1rem;
    }
}
</style>