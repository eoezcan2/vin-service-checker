<script setup>
import axios from 'axios';
import { ref, defineProps, onMounted } from 'vue';
import { safeRequest } from '@/api';

const categories = ['OILCHANGE', 'TIRECHANGE', 'MISC']

const props = defineProps({
    vin: String,
    edit: Boolean
})

let data = ref([])

let newDate = ref('')
let newCategory = ref('')
let newDescription = ref('')
let newMileage = ref('')
let newCost = ref('')

function getMaintenances() {
    axios.get(`http://localhost:8080/api/maintenance/${props.vin}`)
        .then(response => {
            console.log(response)
            data.value = response.data
        })
        .catch(error => {
            console.log(error)
        })
}

function addMaintenance() {
    console.log(newDate.value, newCategory.value)
    safeRequest('api/maintenance', 'POST', {
        vin: props.vin,
        date: newDate.value,
        category: categories.findIndex(category => category === newCategory.value),
        description: newDescription.value,
        mileage: newMileage.value,
        cost: newCost.value
    }).then(response => {
        console.log(response)
        getMaintenances()
    }).catch(error => {
        console.log(error)
    })
}

function removeMaintenance(id) {
  console.log(id)
  safeRequest(`api/maintenance/${id}`, 'DELETE', {})
    .then(response => {
        console.log(response)
        getMaintenances()
    }).catch(error => {
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
    <div>
        <table class="table table-striped table-hover">
            <thead class="table-dark">
                <tr>
                    <th scope="col">Datum</th>
                    <th scope="col">Art</th>
                    <th scope="col">Notiz</th>
                    <th scope="col">Kilometerstand</th>
                    <th scope="col">Kosten</th>
                    <th scope="col" v-if="props.edit"></th>
                </tr>
            </thead>
            <tbody>
                <tr v-for="item in data" :key="item.id">
                    <td>{{ convertDate(item.date) }}</td>
                    <td>{{ item.category }}</td>
                    <td>{{ item.description }}</td>
                    <td>{{ item.mileage }} km</td>
                    <td>{{ item.cost }}€</td>
                    <td v-if="props.edit"><button class="btn btn-danger" @click="removeMaintenance(item.id)">-</button></td>
                </tr>
                <tr v-if="props.edit">
                    <td><input type="date" class="form-control" id="dateInput" v-model="newDate"></td>
                    <td>
                      <select v-model="newCategory">
                        <option v-for="category in categories" :key="category">{{ category }}</option>
                      </select>
                    </td>
                    <td><input type="text" class="form-control" id="descriptionInput" v-model="newDescription"></td>
                    <td><input type="number" class="form-control" id="mileageInput" v-model="newMileage"></td>
                    <td><input type="number" class="form-control" id="costInput" v-model="newCost"></td>
                    <td><button class="btn btn-primary" @click="addMaintenance">+</button></td>
                </tr>
            </tbody>
        </table>
    </div>
</template>