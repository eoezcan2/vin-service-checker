<script setup>
    import { isTokenPresent } from '@/api';
    import axios from 'axios';
    import { onMounted, ref } from 'vue'
    import { useRouter } from 'vue-router'

    const username = ref('')
    const password = ref('')

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
</script>

<template>
    <div class="container w-25">
        <div class="mb-3">
            <label for="usernameInput" class="form-label">Username</label>
            <input type="text" class="form-control" id="usernameInput" v-model="username" aria-describedby="usernameHelp" v-on:keyup.enter="login">
            <!--<div id="usernameHelp" class="form-text">We'll never share your email with anyone else.</div>-->
        </div>
        <div class="mb-3">
            <label for="passwordInput" class="form-label">Password</label>
            <input type="password" class="form-control" id="passwordInput" v-model="password" v-on:keyup.enter="login">
        </div>
        <button class="btn btn-primary" @click="login">Login</button>
    </div>
</template>

<style scoped>
</style>