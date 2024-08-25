<script setup>
import { useRoute } from 'vue-router';
import { onMounted, ref } from 'vue';
import axios from 'axios';

const route = useRoute()
const vin = ref(route.params.vin)

const data = ref({})
const loaded = ref(false)

onMounted(() => {
    axios.get(`http://localhost:3000/api/vin/${route.params.vin}/data`)
        .then(response => {
            console.log(response)
            data.value = response.data
            loaded.value = true
        })
        .catch(error => {
            console.log(error)
        })
})

function capitalizeFirstLetter(string) {
    return string.charAt(0).toUpperCase() + string.slice(1);
}
</script>

<template>
    <div v-if="loaded">
        <p>Name: <b>{{ data.name }}</b></p>
        <p>Type: <b>{{ capitalizeFirstLetter(data.type) }}</b></p>
        <p>VIN: <b>{{ vin }}</b></p>
    </div>
    <button @click="$router.push('/')">Back</button>
</template>