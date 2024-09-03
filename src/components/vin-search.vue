<script setup>
    import { ref } from 'vue'
    import axios from 'axios'
    import { useRouter } from 'vue-router'

    const inputVin = ref('')
    const apiError = ref(false)
    const router = useRouter()

    function submitSearch() {
        if (!inputVin.value) return
        axios.get(`http://localhost:8080/api/vin/${inputVin.value}`).then(response => {
            if (response.status !== 200) {
                throw new Error('Not found')
            }
            apiError.value = false
            router.push(`/vin/${inputVin.value}`)
        }).catch(error => {
            console.log(error)
            apiError.value = true
            inputVin.value = ''
        })
    }
</script>

<template>
    <div class="container-fluid d-flex justify-content-center flex-column w-25">
        <input class="form-control text-center" type="text" v-model="inputVin" placeholder="FIN" v-on:keyup.enter="submitSearch">
        <p class="text-danger pt-2" v-if="apiError">Nicht gefunden</p>
    </div>
</template>

<style scoped>
</style>