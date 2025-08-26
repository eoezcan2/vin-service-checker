<script setup>
import { useRoute } from 'vue-router';
import { ref } from 'vue';
import MaintenanceComponent from '../maintenance-component.vue';
import VehiclecardComponent from '../vehiclecard-component.vue';

const route = useRoute()
const vin = ref(route.params.vin)

</script>

<template>
    <div>
        <VehiclecardComponent :vin="vin" />
        <div class="d-flex justify-content-center align-items-center">
            <MaintenanceComponent :vin="vin" class="w-75" />
        </div>
    </div>
</template>