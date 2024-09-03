<script setup>
import axios from 'axios';
import { defineProps, onMounted, ref } from 'vue'

const props = defineProps(['vin'])
let data = ref([])
const loaded = ref(false)
let imgSrc = ref('')

onMounted(() => {
    axios.get(`http://localhost:8080/api/vin/${props.vin}/data`)
        .then(response => {
            console.log(response)
            data.value = response.data
            determineImageSource()
            loaded.value = true
        })
        .catch(error => {
            console.log(error)
        })
})

function determineImageSource() {
    if (data.value.type === 'CAR') {
        imgSrc.value = '/car.svg'
    } else if (data.value.type === 'MOTORCYCLE') {
        imgSrc.value = '/motorcycle.svg'
    }
}

</script>

<template>
    <div class="pb-5 d-flex justify-content-center align-items-center" v-if="loaded">
        <div class="card" style="width: 18rem;">
            <img :src="imgSrc" class="card-img-top pt-3" :alt="data.type" width="100" height="100">
            <div class="card-body">
                <h5 class="card-title">{{ data.name }}</h5>
                <p class="card-text">{{ vin }}</p>
            </div>
        </div>
    </div>
</template>