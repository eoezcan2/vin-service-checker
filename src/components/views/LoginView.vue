<script setup>
    import axios from 'axios';
    import { ref } from 'vue'
    import { useRouter } from 'vue-router'

    const email = ref('')
    const password = ref('')

    const router = useRouter()

    const login = () => {
        axios.post('http://localhost:3000/users/login', {
            email: email.value,
            password: password.value
        })
        .then((response) => {
            if (response.status === 200) {
                router.push('/')
            }
        })
        .catch((error) => {
            console.log(error)
            alert('Login failed')
        })
    }
</script>

<template>
    <div>
        <input type="text" v-model="email" placeholder="Email">
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