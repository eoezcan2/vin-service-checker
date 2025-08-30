<script setup>
    import { isTokenPresent, login as loginUser } from '@/api';
    import axios from 'axios';
    import { onMounted, ref } from 'vue'
    import { useRouter } from 'vue-router'

    const username = ref('')
    const password = ref('')

    const registerUsername = ref('')
    const registerEmail = ref('')
    const registerPassword = ref('')

    // Error and loading states
    const loginError = ref('')
    const registerError = ref('')
    const isLoginLoading = ref(false)
    const isRegisterLoading = ref(false)

    const router = useRouter()

    onMounted(() => {
        if (isTokenPresent.value) {
            router.push('/')
        }
    })
    
    const login = async () => {
        // Clear previous errors
        loginError.value = ''
        
        // Validate inputs
        if (!username.value.trim() || !password.value.trim()) {
            loginError.value = 'Bitte füllen Sie alle Felder aus.'
            return
        }

        isLoginLoading.value = true
        
        try {
            const API_BASE_URL = process.env.VUE_APP_API_URL || 'http://localhost:8080';
            const response = await axios.post(`${API_BASE_URL}/user/login`, {
                username: username.value.trim(),
                password: password.value
            })
            
            if (response.data && response.data.token) {
                loginUser(response.data.token)
                router.push('/')
            } else {
                loginError.value = 'Ungültige Anmeldedaten. Bitte überprüfen Sie Benutzername und Passwort.'
            }
        } catch (error) {
            if (error.response) {
                // Server responded with error status
                if (error.response.status === 401) {
                    loginError.value = 'Ungültige Anmeldedaten. Bitte überprüfen Sie Benutzername und Passwort.'
                } else if (error.response.status === 404) {
                    loginError.value = 'Benutzer nicht gefunden. Bitte überprüfen Sie Ihren Benutzernamen.'
                } else if (error.response.status === 500) {
                    loginError.value = 'Serverfehler. Bitte versuchen Sie es später erneut.'
                } else {
                    loginError.value = 'Anmeldung fehlgeschlagen. Bitte versuchen Sie es erneut.'
                }
            } else if (error.request) {
                // Network error
                loginError.value = 'Verbindungsfehler. Bitte überprüfen Sie Ihre Internetverbindung.'
            } else {
                // Other error
                loginError.value = 'Ein unerwarteter Fehler ist aufgetreten. Bitte versuchen Sie es erneut.'
            }
        } finally {
            isLoginLoading.value = false
        }
    }

    const register = async () => {
        // Clear previous errors
        registerError.value = ''
        
        // Validate inputs
        if (!registerUsername.value.trim() || !registerEmail.value.trim() || !registerPassword.value.trim()) {
            registerError.value = 'Bitte füllen Sie alle Felder aus.'
            return
        }

        if (registerPassword.value.length < 6) {
            registerError.value = 'Das Passwort muss mindestens 6 Zeichen lang sein.'
            return
        }

        // Basic email validation
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
        if (!emailRegex.test(registerEmail.value)) {
            registerError.value = 'Bitte geben Sie eine gültige E-Mail-Adresse ein.'
            return
        }

        isRegisterLoading.value = true
        
        try {
            const API_BASE_URL = process.env.VUE_APP_API_URL || 'http://localhost:8080';
            const response = await axios.post(`${API_BASE_URL}/user/register`, {
                username: registerUsername.value.trim(),
                email: registerEmail.value.trim(),
                password: registerPassword.value
            })
            
            if (response.data && response.data.token) {
                loginUser(response.data.token)
                router.push('/')
            } else {
                registerError.value = 'Registrierung fehlgeschlagen. Bitte versuchen Sie es erneut.'
            }
        } catch (error) {
            if (error.response) {
                // Server responded with error status
                if (error.response.status === 409) {
                    registerError.value = 'Benutzername oder E-Mail-Adresse bereits vorhanden. Bitte wählen Sie andere Daten.'
                } else if (error.response.status === 400) {
                    registerError.value = 'Ungültige Eingabedaten. Bitte überprüfen Sie Ihre Angaben.'
                } else if (error.response.status === 500) {
                    registerError.value = 'Serverfehler. Bitte versuchen Sie es später erneut.'
                } else {
                    registerError.value = 'Registrierung fehlgeschlagen. Bitte versuchen Sie es erneut.'
                }
            } else if (error.request) {
                // Network error
                registerError.value = 'Verbindungsfehler. Bitte überprüfen Sie Ihre Internetverbindung.'
            } else {
                // Other error
                registerError.value = 'Ein unerwarteter Fehler ist aufgetreten. Bitte versuchen Sie es erneut.'
            }
        } finally {
            isRegisterLoading.value = false
        }
    }

    const goBack = () => {
        router.push('/');
    }
</script>

<template>
    <div class="login-container">
        <!-- Back Button -->
        <div class="back-button-container">
            <button class="back-btn" @click="goBack" title="Zurück zur Startseite">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M19 12H5M12 19l-7-7 7-7"/>
                </svg>
                Zurück zur Startseite
            </button>
        </div>

        <!-- Login Form -->
        <div class="form-container">
            <div class="login-form">
                <h2 class="form-title">Anmelden</h2>
                
                <!-- Login Error Message -->
                <div v-if="loginError" class="error-message">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <circle cx="12" cy="12" r="10"/>
                        <line x1="15" y1="9" x2="9" y2="15"/>
                        <line x1="9" y1="9" x2="15" y2="15"/>
                    </svg>
                    {{ loginError }}
                </div>
                
                <div class="form-group">
                    <label for="usernameInput" class="form-label">Benutzername</label>
                    <input 
                        type="text" 
                        class="form-control" 
                        id="usernameInput" 
                        v-model="username" 
                        v-on:keyup.enter="login"
                        :disabled="isLoginLoading"
                        :class="{ 'error': loginError }"
                    >
                </div>
                <div class="form-group">
                    <label for="passwordInput" class="form-label">Passwort</label>
                    <input 
                        type="password" 
                        class="form-control" 
                        id="passwordInput" 
                        v-model="password" 
                        v-on:keyup.enter="login"
                        :disabled="isLoginLoading"
                        :class="{ 'error': loginError }"
                    >
                </div>
                <button 
                    class="btn btn-primary login-btn" 
                    @click="login"
                    :disabled="isLoginLoading"
                >
                    <span v-if="isLoginLoading" class="loading-spinner">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M21 12a9 9 0 11-6.219-8.56"/>
                        </svg>
                    </span>
                    {{ isLoginLoading ? 'Anmelden...' : 'Anmelden' }}
                </button>
            </div>
        </div>

        <!-- Register Section -->
        <div class="register-section">
            <p class="register-title">Noch kein Konto?</p>
            <div class="register-form">
                <h3 class="form-title">Registrieren</h3>
                
                <!-- Register Error Message -->
                <div v-if="registerError" class="error-message">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <circle cx="12" cy="12" r="10"/>
                        <line x1="15" y1="9" x2="9" y2="15"/>
                        <line x1="9" y1="9" x2="15" y2="15"/>
                    </svg>
                    {{ registerError }}
                </div>
                
                <div class="form-group">
                    <label for="registerEmail" class="form-label">E-Mail</label>
                    <input 
                        type="email" 
                        class="form-control" 
                        id="registerEmail" 
                        v-model="registerEmail" 
                        v-on:keyup.enter="register"
                        :disabled="isRegisterLoading"
                        :class="{ 'error': registerError }"
                    >
                </div>
                <div class="form-group">
                    <label for="registerUsername" class="form-label">Benutzername</label>
                    <input 
                        type="text" 
                        class="form-control" 
                        id="registerUsername" 
                        v-model="registerUsername" 
                        v-on:keyup.enter="register"
                        :disabled="isRegisterLoading"
                        :class="{ 'error': registerError }"
                    >
                </div>
                <div class="form-group">
                    <label for="registerPassword" class="form-label">Passwort</label>
                    <input 
                        type="password" 
                        class="form-control" 
                        id="registerPassword" 
                        v-model="registerPassword" 
                        v-on:keyup.enter="register"
                        :disabled="isRegisterLoading"
                        :class="{ 'error': registerError }"
                    >
                </div>
                <button 
                    class="btn btn-primary register-btn" 
                    @click="register"
                    :disabled="isRegisterLoading"
                >
                    <span v-if="isRegisterLoading" class="loading-spinner">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M21 12a9 9 0 11-6.219-8.56"/>
                        </svg>
                    </span>
                    {{ isRegisterLoading ? 'Registrieren...' : 'Registrieren' }}
                </button>
            </div>
        </div>
    </div>
</template>

<style scoped>
.login-container {
    max-width: 800px;
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

.form-container {
    background: #ffffff;
    border-radius: 16px;
    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
    border: 1px solid rgba(0, 0, 0, 0.08);
    overflow: hidden;
    margin-bottom: 2rem;
}

.login-form {
    padding: 2rem;
}

.form-title {
    color: #212529;
    font-weight: 700;
    font-size: 1.5rem;
    margin-bottom: 1.5rem;
    text-align: center;
    background: linear-gradient(135deg, #0d6efd, #0b5ed7);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    background-clip: text;
}

.form-group {
    margin-bottom: 1.5rem;
}

.form-label {
    color: #495057;
    font-weight: 600;
    font-size: 0.9rem;
    margin-bottom: 0.5rem;
    display: block;
}

.form-control {
    width: 100%;
    padding: 0.75rem 1rem;
    border: 2px solid rgba(0, 0, 0, 0.1);
    border-radius: 8px;
    font-size: 1rem;
    background: #ffffff;
    transition: all 0.3s ease;
    font-family: inherit;
}

.form-control:focus {
    outline: none;
    border-color: #0d6efd;
    box-shadow: 0 0 0 3px rgba(13, 110, 253, 0.1);
}

.form-control.error {
    border-color: #dc3545;
    box-shadow: 0 0 0 3px rgba(220, 53, 69, 0.1);
}

.form-control:disabled {
    background-color: #f8f9fa;
    cursor: not-allowed;
    opacity: 0.7;
}

/* Error Message Styling */
.error-message {
    display: flex;
    align-items: center;
    gap: 0.5rem;
    padding: 0.75rem 1rem;
    background: linear-gradient(135deg, #fff5f5, #fed7d7);
    border: 1px solid #feb2b2;
    border-radius: 8px;
    color: #c53030;
    font-size: 0.9rem;
    font-weight: 500;
    margin-bottom: 1.5rem;
    animation: slideIn 0.3s ease;
}

.error-message svg {
    flex-shrink: 0;
    color: #e53e3e;
}

@keyframes slideIn {
    from {
        opacity: 0;
        transform: translateY(-10px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

.login-btn, .register-btn {
    width: 100%;
    padding: 0.75rem 2rem;
    background: linear-gradient(135deg, #0d6efd, #0b5ed7);
    border: none;
    border-radius: 8px;
    color: #ffffff;
    font-size: 1rem;
    font-weight: 600;
    cursor: pointer;
    transition: all 0.3s ease;
}

.login-btn:hover, .register-btn:hover {
    background: linear-gradient(135deg, #0b5ed7, #0a58ca);
    transform: translateY(-2px);
    box-shadow: 0 6px 20px rgba(13, 110, 253, 0.3);
}

.login-btn:disabled, .register-btn:disabled {
    background: linear-gradient(135deg, #6c757d, #5a6268);
    cursor: not-allowed;
    transform: none;
    box-shadow: none;
}

.login-btn:disabled:hover, .register-btn:disabled:hover {
    background: linear-gradient(135deg, #6c757d, #5a6268);
    transform: none;
    box-shadow: none;
}

/* Loading Spinner */
.loading-spinner {
    display: inline-block;
    animation: spin 1s linear infinite;
    margin-right: 0.5rem;
}

@keyframes spin {
    from { transform: rotate(0deg); }
    to { transform: rotate(360deg); }
}

.register-section {
    background: #ffffff;
    border-radius: 16px;
    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
    border: 1px solid rgba(0, 0, 0, 0.08);
    overflow: hidden;
}

.register-title {
    text-align: center;
    font-weight: 700;
    font-size: 1.2rem;
    margin: 1.5rem 0;
    color: #495057;
}

.register-form {
    padding: 2rem;
}

/* Responsive Design */
@media (max-width: 768px) {
    .login-container {
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
    
    .login-form, .register-form {
        padding: 1.5rem;
    }
}

@media (max-width: 480px) {
    .back-btn {
        width: 100%;
        justify-content: center;
    }
    
    .login-form, .register-form {
        padding: 1rem;
    }
}
</style>