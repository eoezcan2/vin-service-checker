<script setup>
import { useRoute } from 'vue-router';
import { onMounted, ref } from 'vue';

const route = useRoute()
const vin = ref(route.params.vin)

const data = ref({})
const loaded = ref(false)

onMounted(() => {
    console.log(route.params.vin)
    fetch(`http://localhost:3000/api/vin/${route.params.vin}/data`)
        .then(response => response.json())
        .then(response => {
            data.value = response
            loaded.value = true
        })
        .catch(error => {
            console.log(error)
        })
})
</script>

<template>
    <div v-if="loaded">
        <p>Name: <b>{{ data.name }}</b></p>
        <p>Type: <b>{{ data.type }}</b></p>
        <p>VIN: <b>{{ vin }}</b></p>
    </div>
    <button @click="$router.push('/')">Back</button>
</template>