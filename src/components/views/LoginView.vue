<script setup>
    import { isTokenPresent } from '@/api';
import axios from 'axios';
    import { onMounted, ref } from 'vue'
    import { useRouter } from 'vue-router'

    const username = ref('')
    const password = ref('')

    const router = useRouter()

    onMounted(() => {
        if (isTokenPresent) router.push('/')
    })
    
    const login = () => {
        axios.post('http://localhost:8080/user/login', {
            username: username.value,
            password: password.value
        }).then((response) => {
            if (response.status === 200) {
                localStorage.setItem('token', response.data.token)
                router.push('/')
                location.reload()
            }
        }).catch((error) => {
            console.log(error)
            alert('Login failed')
        })
    }
</script>

<template>
    <div>
        <input type="text" v-model="username" placeholder="Username">
        <input type="password" v-model="password" placeholder="Password">
        <button @click="login">Login</button>
    </div>
</template>

<style scoped>
    div {
        margin-top: 30px;
        display: flex;
        flex-direction: column;
        align-items: center;
    }

    input {
        margin-bottom: 10px;
        width: 15%;
        min-width: 200px;
        height: 2rem;
        text-align: center;
        font-size: 1rem;
    }

    button {
        border: none;
        border-radius: 5px;
        padding: 10px;
        cursor: pointer;
        background-color: #4CAF50;
        color: white;
        width: 100px;
        font-size: 1rem;
    }
</style>