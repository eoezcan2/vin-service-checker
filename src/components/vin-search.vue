<script setup>
    import { ref } from 'vue'
    import axios from 'axios'
    import { useRouter } from 'vue-router'

    const inputVin = ref('')
    const apiError = ref(false)
    const router = useRouter()

    function submitSearch() {
        axios.get(`http://localhost:3000/api/vin/${inputVin.value}`)
            .then(response => {
                if (response.status !== 200) {
                    throw new Error('Not found')
                }
                apiError.value = false
                router.push(`/vin/${inputVin.value}`)
            })
            .catch(error => {
                console.log(error)
                apiError.value = true
            })
    }
</script>

<template>
    <div>
        <input type="text" v-model="inputVin" placeholder="VIN" v-on:keyup.enter="submitSearch">
        <p class="error" v-if="apiError">Not found</p>
    </div>
</template>

<style scoped>
    div {
        margin-top: 30px;
    }

    .error {
        color: red;
    }

    input[type="text"] {
        width: 25%;
        min-width: 200px;
        height: 2rem;
        text-align: center;
        font-size: 1rem;
    }

    button {
        width: 30px;
    }

    button svg {
        fill: #fff;
    }
</style>