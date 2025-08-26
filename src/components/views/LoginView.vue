<script setup>
    import { isTokenPresent } from '@/api';
    import axios from 'axios';
    import { onMounted, ref } from 'vue'
    import { useRouter } from 'vue-router'

    const username = ref('')
    const password = ref('')

    const registerUsername = ref('')
    const registerEmail = ref('')
    const registerPassword = ref('')

    const router = useRouter()

    onMounted(() => {
        if (isTokenPresent) {
            router.push('/')
        }
    })
    
    const login = () => {
        axios.post('http://localhost:8080/user/login', {
            username: username.value,
            password: password.value
        }).then((response) => {
            console.log(response)
            if (response.status === 200) {
                console.log(response.data.token)
                localStorage.setItem('token', response.data.token)
                router.push('/')
                location.reload()
            }
        }).catch((error) => {
            console.log(error)
            alert('Login failed')
        })
    }

    const register = () => {
      axios.post('http://localhost:8080/user/register', {
          username: registerUsername.value,
          email: registerEmail.value,
          password: registerPassword.value
      }).then((response) => {
          console.log(response)
          if (response.status === 200) {
              console.log(response.data.token)
              localStorage.setItem('token', response.data.token)
              router.push('/')
              location.reload()
          }
      }).catch((error) => {
          console.log(error)
          alert('Register failed')
      })
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
                <div class="form-group">
                    <label for="usernameInput" class="form-label">Benutzername</label>
                    <input type="text" class="form-control" id="usernameInput" v-model="username" v-on:keyup.enter="login">
                </div>
                <div class="form-group">
                    <label for="passwordInput" class="form-label">Passwort</label>
                    <input type="password" class="form-control" id="passwordInput" v-model="password" v-on:keyup.enter="login">
                </div>
                <button class="btn btn-primary login-btn" @click="login">Anmelden</button>
            </div>
        </div>

        <!-- Register Section -->
        <div class="register-section">
            <p class="register-title">Noch kein Konto?</p>
            <div class="register-form">
                <h3 class="form-title">Registrieren</h3>
                <div class="form-group">
                    <label for="registerEmail" class="form-label">E-Mail</label>
                    <input type="email" class="form-control" id="registerEmail" v-model="registerEmail" v-on:keyup.enter="register">
                </div>
                <div class="form-group">
                    <label for="registerUsername" class="form-label">Benutzername</label>
                    <input type="text" class="form-control" id="registerUsername" v-model="registerUsername" v-on:keyup.enter="register">
                </div>
                <div class="form-group">
                    <label for="registerPassword" class="form-label">Passwort</label>
                    <input type="password" class="form-control" id="registerPassword" v-model="registerPassword" v-on:keyup.enter="register">
                </div>
                <button class="btn btn-primary register-btn" @click="register">Registrieren</button>
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