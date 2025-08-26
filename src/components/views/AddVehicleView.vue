<script setup>
import { ref, reactive } from 'vue';
import { useRouter } from 'vue-router';
import { safeRequest } from '@/api';

const router = useRouter();

// Form data
const formData = reactive({
    name: '',
    vin: '',
    type: '',
    year: '',
    mileage: '',
    description: ''
});

// Form validation
const errors = reactive({
    name: '',
    vin: '',
    type: '',
    year: '',
    mileage: ''
});

const isLoading = ref(false);
const isSubmitted = ref(false);

// Vehicle types
const vehicleTypes = [
    { value: 'CAR', label: 'Auto', icon: '🚗' },
    { value: 'MOTORCYCLE', label: 'Motorrad', icon: '🏍️' }
];

// Validation functions
function validateName() {
    if (!formData.name.trim()) {
        errors.name = 'Fahrzeugname ist erforderlich';
        return false;
    }
    if (formData.name.length < 2) {
        errors.name = 'Fahrzeugname muss mindestens 2 Zeichen lang sein';
        return false;
    }
    errors.name = '';
    return true;
}

function validateVin() {
    if (!formData.vin.trim()) {
        errors.vin = 'VIN ist erforderlich';
        return false;
    }
    if (formData.vin.length < 17) {
        errors.vin = 'VIN muss 17 Zeichen lang sein';
        return false;
    }
    errors.vin = '';
    return true;
}

function validateType() {
    if (!formData.type) {
        errors.type = 'Fahrzeugtyp ist erforderlich';
        return false;
    }
    errors.type = '';
    return true;
}

function validateYear() {
    if (formData.year) {
        const year = parseInt(formData.year);
        const currentYear = new Date().getFullYear();
        if (year < 1900 || year > currentYear + 1) {
            errors.year = `Jahr muss zwischen 1900 und ${currentYear + 1} liegen`;
            return false;
        }
    }
    errors.year = '';
    return true;
}

function validateMileage() {
    if (formData.mileage) {
        const mileage = parseInt(formData.mileage);
        if (mileage < 0 || mileage > 999999) {
            errors.mileage = 'Kilometerstand muss zwischen 0 und 999.999 liegen';
            return false;
        }
    }
    errors.mileage = '';
    return true;
}

function validateForm() {
    const isNameValid = validateName();
    const isVinValid = validateVin();
    const isTypeValid = validateType();
    const isYearValid = validateYear();
    const isMileageValid = validateMileage();
    
    return isNameValid && isVinValid && isTypeValid && isYearValid && isMileageValid;
}

// Form submission
async function submitForm() {
    if (!validateForm()) {
        return;
    }

    isLoading.value = true;
    
    try {
        const response = await safeRequest('api/vin', 'POST', {
            name: formData.name.trim(),
            vin: formData.vin.trim().toUpperCase(),
            type: formData.type,
            year: formData.year ? parseInt(formData.year) : null,
            mileage: formData.mileage ? parseInt(formData.mileage) : null,
            description: formData.description.trim()
        });

        console.log('Vehicle added successfully:', response);
        isSubmitted.value = true;
        
        // Redirect to home page after successful submission
        setTimeout(() => {
            router.push('/');
        }, 2000);
        
    } catch (error) {
        console.error('Error adding vehicle:', error);
        // Handle specific errors here if needed
    } finally {
        isLoading.value = false;
    }
}

function resetForm() {
    Object.keys(formData).forEach(key => {
        formData[key] = '';
    });
    Object.keys(errors).forEach(key => {
        errors[key] = '';
    });
    isSubmitted.value = false;
}
</script>

<template>
    <div class="add-vehicle-container">
        <!-- Page Header -->
        <div class="page-header">
            <div class="header-content">
                <h1 class="page-title">Fahrzeug hinzufügen</h1>
                <p class="page-subtitle">Fügen Sie ein neues Fahrzeug zu Ihrer Wartungsverwaltung hinzu</p>
            </div>
            <div class="header-icon">
                <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M12 5v14M5 12h14"/>
                </svg>
            </div>
        </div>

        <!-- Success Message -->
        <div v-if="isSubmitted" class="success-message">
            <div class="success-icon">✅</div>
            <h3>Fahrzeug erfolgreich hinzugefügt!</h3>
            <p>Sie werden zur Startseite weitergeleitet...</p>
        </div>

        <!-- Add Vehicle Form -->
        <div v-else class="form-container">
            <form @submit.prevent="submitForm" class="vehicle-form">
                <!-- Vehicle Name -->
                <div class="form-group">
                    <label for="vehicleName" class="form-label">
                        <span class="label-icon">🚗</span>
                        Fahrzeugname *
                    </label>
                    <input
                        id="vehicleName"
                        v-model="formData.name"
                        type="text"
                        class="form-input"
                        :class="{ 'error': errors.name }"
                        placeholder="z.B. Mein Auto, BMW X5, etc."
                        @blur="validateName"
                    >
                    <span v-if="errors.name" class="error-message">{{ errors.name }}</span>
                </div>

                <!-- VIN -->
                <div class="form-group">
                    <label for="vehicleVin" class="form-label">
                        <span class="label-icon">🔢</span>
                        Fahrzeug-Identifikationsnummer (VIN) *
                    </label>
                    <input
                        id="vehicleVin"
                        v-model="formData.vin"
                        type="text"
                        class="form-input"
                        :class="{ 'error': errors.vin }"
                        placeholder="17-stellige VIN eingeben"
                        maxlength="17"
                        @blur="validateVin"
                    >
                    <span v-if="errors.vin" class="error-message">{{ errors.vin }}</span>
                    <small class="form-help">Die VIN ist eine 17-stellige alphanumerische Kennung</small>
                </div>

                <!-- Vehicle Type -->
                <div class="form-group">
                    <label for="vehicleType" class="form-label">
                        <span class="label-icon">🏷️</span>
                        Fahrzeugtyp *
                    </label>
                    <select
                        id="vehicleType"
                        v-model="formData.type"
                        class="form-select"
                        :class="{ 'error': errors.type }"
                        @blur="validateType"
                    >
                        <option value="" disabled>Fahrzeugtyp auswählen</option>
                        <option v-for="type in vehicleTypes" :key="type.value" :value="type.value">
                            {{ type.icon }} {{ type.label }}
                        </option>
                    </select>
                    <span v-if="errors.type" class="error-message">{{ errors.type }}</span>
                </div>

                <!-- Year and Mileage Row -->
                <div class="form-row">
                    <div class="form-group">
                        <label for="vehicleYear" class="form-label">
                            <span class="label-icon">📅</span>
                            Baujahr
                        </label>
                        <input
                            id="vehicleYear"
                            v-model="formData.year"
                            type="number"
                            class="form-input"
                            :class="{ 'error': errors.year }"
                            placeholder="z.B. 2020"
                            min="1900"
                            :max="new Date().getFullYear() + 1"
                            @blur="validateYear"
                        >
                        <span v-if="errors.year" class="error-message">{{ errors.year }}</span>
                    </div>

                    <div class="form-group">
                        <label for="vehicleMileage" class="form-label">
                            <span class="label-icon">🛣️</span>
                            Kilometerstand
                        </label>
                        <input
                            id="vehicleMileage"
                            v-model="formData.mileage"
                            type="number"
                            class="form-input"
                            :class="{ 'error': errors.mileage }"
                            placeholder="z.B. 50000"
                            min="0"
                            max="999999"
                            @blur="validateMileage"
                        >
                        <span v-if="errors.mileage" class="error-message">{{ errors.mileage }}</span>
                    </div>
                </div>

                <!-- Description -->
                <div class="form-group">
                    <label for="vehicleDescription" class="form-label">
                        <span class="label-icon">📝</span>
                        Beschreibung (optional)
                    </label>
                    <textarea
                        id="vehicleDescription"
                        v-model="formData.description"
                        class="form-textarea"
                        placeholder="Zusätzliche Informationen über das Fahrzeug..."
                        rows="3"
                    ></textarea>
                </div>

                <!-- Form Actions -->
                <div class="form-actions">
                    <button
                        type="button"
                        class="btn btn-secondary"
                        @click="resetForm"
                        :disabled="isLoading"
                    >
                        Zurücksetzen
                    </button>
                    <button
                        type="submit"
                        class="btn btn-primary"
                        :disabled="isLoading"
                    >
                        <span v-if="isLoading" class="loading-spinner"></span>
                        <span v-else>Fahrzeug hinzufügen</span>
                    </button>
                </div>
            </form>
        </div>
    </div>
</template>

<style scoped>
/* Container */
.add-vehicle-container {
    max-width: 800px;
    margin: 0 auto;
    padding: 2rem 1rem;
}

/* Page Header */
.page-header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin-bottom: 3rem;
    padding: 2rem;
    background: linear-gradient(135deg, #ffffff, #f8f9fa);
    border-radius: 16px;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.06);
    border: 1px solid rgba(13, 110, 253, 0.08);
}

.header-content {
    flex: 1;
}

.page-title {
    color: #212529;
    font-weight: 700;
    font-size: 2.5rem;
    margin: 0 0 0.5rem 0;
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

.header-icon {
    color: #0d6efd;
    opacity: 0.8;
}

/* Success Message */
.success-message {
    text-align: center;
    padding: 3rem 2rem;
    background: linear-gradient(135deg, #d4edda, #c3e6cb);
    border-radius: 16px;
    border: 1px solid #c3e6cb;
    color: #155724;
}

.success-icon {
    font-size: 4rem;
    margin-bottom: 1rem;
}

.success-message h3 {
    margin: 0 0 0.5rem 0;
    font-weight: 600;
}

.success-message p {
    margin: 0;
    opacity: 0.8;
}

/* Form Container */
.form-container {
    background: #ffffff;
    border-radius: 16px;
    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
    border: 1px solid rgba(0, 0, 0, 0.08);
    overflow: hidden;
}

.vehicle-form {
    padding: 2rem;
}

/* Form Groups */
.form-group {
    margin-bottom: 1.5rem;
}

.form-row {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 1rem;
}

.form-label {
    display: flex;
    align-items: center;
    gap: 0.5rem;
    color: #495057;
    font-weight: 600;
    font-size: 0.9rem;
    margin-bottom: 0.5rem;
    text-transform: uppercase;
    letter-spacing: 0.5px;
}

.label-icon {
    font-size: 1rem;
}

/* Form Inputs */
.form-input,
.form-select,
.form-textarea {
    width: 100%;
    padding: 0.75rem 1rem;
    border: 2px solid rgba(0, 0, 0, 0.1);
    border-radius: 8px;
    font-size: 1rem;
    background: #ffffff;
    transition: all 0.3s ease;
    font-family: inherit;
}

.form-input:focus,
.form-select:focus,
.form-textarea:focus {
    outline: none;
    border-color: #0d6efd;
    box-shadow: 0 0 0 3px rgba(13, 110, 253, 0.1);
}

.form-input.error,
.form-select.error {
    border-color: #dc3545;
    box-shadow: 0 0 0 3px rgba(220, 53, 69, 0.1);
}

.form-input::placeholder,
.form-textarea::placeholder {
    color: #adb5bd;
}

.form-textarea {
    resize: vertical;
    min-height: 100px;
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

/* Error Messages */
.error-message {
    color: #dc3545;
    font-size: 0.85rem;
    margin-top: 0.25rem;
    display: block;
}

.form-help {
    color: #6c757d;
    font-size: 0.85rem;
    margin-top: 0.25rem;
    display: block;
}

/* Form Actions */
.form-actions {
    display: flex;
    gap: 1rem;
    justify-content: flex-end;
    margin-top: 2rem;
    padding-top: 2rem;
    border-top: 1px solid rgba(0, 0, 0, 0.06);
}

.btn {
    padding: 0.75rem 2rem;
    border: none;
    border-radius: 8px;
    font-size: 1rem;
    font-weight: 600;
    cursor: pointer;
    transition: all 0.3s ease;
    display: flex;
    align-items: center;
    gap: 0.5rem;
    text-decoration: none;
}

.btn:disabled {
    opacity: 0.6;
    cursor: not-allowed;
}

.btn-primary {
    background: linear-gradient(135deg, #0d6efd, #0b5ed7);
    color: #ffffff;
    box-shadow: 0 4px 12px rgba(13, 110, 253, 0.2);
}

.btn-primary:hover:not(:disabled) {
    background: linear-gradient(135deg, #0b5ed7, #0a58ca);
    transform: translateY(-2px);
    box-shadow: 0 6px 20px rgba(13, 110, 253, 0.3);
}

.btn-secondary {
    background: rgba(255, 255, 255, 0.8);
    color: #6c757d;
    border: 1px solid rgba(0, 0, 0, 0.1);
}

.btn-secondary:hover:not(:disabled) {
    background: #ffffff;
    color: #495057;
    transform: translateY(-2px);
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
}

/* Loading Spinner */
.loading-spinner {
    width: 16px;
    height: 16px;
    border: 2px solid rgba(255, 255, 255, 0.3);
    border-top: 2px solid #ffffff;
    border-radius: 50%;
    animation: spin 1s linear infinite;
}

@keyframes spin {
    0% { transform: rotate(0deg); }
    100% { transform: rotate(360deg); }
}

/* Responsive Design */
@media (max-width: 768px) {
    .add-vehicle-container {
        padding: 1rem 0.5rem;
    }
    
    .page-header {
        flex-direction: column;
        text-align: center;
        gap: 1rem;
        padding: 1.5rem;
    }
    
    .page-title {
        font-size: 2rem;
    }
    
    .form-row {
        grid-template-columns: 1fr;
    }
    
    .vehicle-form {
        padding: 1.5rem;
    }
    
    .form-actions {
        flex-direction: column;
    }
    
    .btn {
        width: 100%;
        justify-content: center;
    }
}

@media (max-width: 480px) {
    .page-title {
        font-size: 1.75rem;
    }
    
    .vehicle-form {
        padding: 1rem;
    }
    
    .form-input,
    .form-select,
    .form-textarea {
        padding: 0.6rem 0.8rem;
        font-size: 0.9rem;
    }
}
</style>