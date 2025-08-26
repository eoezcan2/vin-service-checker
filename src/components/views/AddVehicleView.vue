<script setup>
import { ref, reactive } from 'vue';
import { useRouter } from 'vue-router';
import { safeRequest } from '@/api';

const router = useRouter();

// Form data
const formData = reactive({
    name: '',
    vin: '',
    type: ''
});

// Form validation
const errors = reactive({
    name: '',
    vin: '',
    type: ''
});

const isLoading = ref(false);
const isSubmitted = ref(false);
const submitError = ref('');

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



function validateForm() {
    const isNameValid = validateName();
    const isVinValid = validateVin();
    const isTypeValid = validateType();
    
    return isNameValid && isVinValid && isTypeValid;
}

// Form submission
async function submitForm() {
    if (!validateForm()) {
        return;
    }

    // Clear any previous errors
    submitError.value = '';
    
    // Scroll to top when form is submitted
    window.scrollTo({ top: 0, behavior: 'smooth' });

    isLoading.value = true;
    
    try {
        const response = await safeRequest('vehicle/add', 'POST', {
            vin: formData.vin.trim().toUpperCase(),
            name: formData.name.trim(),
            type: formData.type
        });

        console.log('Vehicle:', response);
        
        // Check if the request was successful
        if (response.status === 200 || response.status === 201) {
            isSubmitted.value = true;
            
            // Redirect to vehicles page after successful submission
            setTimeout(() => {
                router.push('/account');
            }, 2000);
        } else {
            // Handle error response
            submitError.value = response.data?.message || 'Fehler beim Hinzufügen des Fahrzeugs. Bitte versuchen Sie es erneut.';
        }
        
    } catch (error) {
        console.error('Error adding vehicle:', error);
        submitError.value = 'Netzwerkfehler. Bitte überprüfen Sie Ihre Verbindung und versuchen Sie es erneut.';
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

function goBack() {
    router.go(-1);
}
</script>

<template>
    <div class="add-vehicle-container">
        <!-- Page Header -->
        <div class="page-header">
            <div class="header-content">
                <div class="header-top">
                    <button class="back-btn" @click="goBack" title="Zurück">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M19 12H5M12 19l-7-7 7-7"/>
                        </svg>
                        Zurück
                    </button>
                </div>
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
            <p>Sie werden zur Fahrzeugliste weitergeleitet...</p>
        </div>

        <!-- Error Message -->
        <div v-if="submitError" class="error-message-container">
            <div class="error-icon">❌</div>
            <h3>Fehler beim Hinzufügen des Fahrzeugs</h3>
            <p>{{ submitError }}</p>
            <button class="btn btn-secondary" @click="submitError = ''">Schließen</button>
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

.header-top {
    margin-bottom: 1rem;
}

.back-btn {
    display: flex;
    align-items: center;
    gap: 0.5rem;
    padding: 0.5rem 1rem;
    background: rgba(255, 255, 255, 0.8);
    border: 1px solid rgba(0, 0, 0, 0.1);
    border-radius: 8px;
    color: #6c757d;
    font-size: 0.9rem;
    font-weight: 600;
    cursor: pointer;
    transition: all 0.3s ease;
    text-decoration: none;
}

.back-btn:hover {
    background: #ffffff;
    color: #495057;
    transform: translateY(-2px);
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
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

/* Error Message */
.error-message-container {
    text-align: center;
    padding: 3rem 2rem;
    background: linear-gradient(135deg, #f8d7da, #f5c6cb);
    border-radius: 16px;
    border: 1px solid #f5c6cb;
    color: #721c24;
    margin-bottom: 2rem;
}

.error-icon {
    font-size: 4rem;
    margin-bottom: 1rem;
}

.error-message-container h3 {
    margin: 0 0 0.5rem 0;
    font-weight: 600;
}

.error-message-container p {
    margin: 0 0 1.5rem 0;
    opacity: 0.9;
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