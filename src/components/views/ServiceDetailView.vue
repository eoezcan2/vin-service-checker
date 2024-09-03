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
        <MaintenanceComponent :vin="vin" />
    </div>
</template>