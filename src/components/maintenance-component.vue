<script setup>
import axios from 'axios';
import { ref, defineProps, onMounted } from 'vue';

const props = defineProps(['vin'])
let data = ref([])

function getMaintenances() {
    console.log(props.vin)
    axios.get(`http://localhost:8080/api/maintenance/${props.vin}`)
        .then(response => {
            console.log(response)
            data.value = response.data
        })
        .catch(error => {
            console.log(error)
        })
}

function convertDate(date) {
    // date string looks like this: 2021-10-10T00:00:00.000+00:00
    return new Date(date).toLocaleDateString()
}

onMounted(() => {
    getMaintenances()
})
</script>

<template>
    <table class="table table-warning table-striped table-hover">
        <thead>
            <tr>
                <th scope="col">Date</th>
                <th scope="col">Category</th>
                <th scope="col">Description</th>
                <th scope="col">Mileage</th>
                <th scope="col">Cost</th>
            </tr>
        </thead>
        <tbody>
            <tr v-for="item in data" :key="item.id">
                <td>{{ convertDate(item.date) }}</td>
                <td>{{ item.category }}</td>
                <td>{{ item.description }}</td>
                <td>{{ item.mileage }}</td>
                <td>{{ item.cost }}</td>
            </tr>
        </tbody>
    </table>
</template>