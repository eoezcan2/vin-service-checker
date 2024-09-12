<script setup>
import {validateLogin} from '@/api';
import {onBeforeMount} from 'vue';
import MaintenanceEditComponent from '../maintenance-edit-component.vue';
import AddVehicleComponent from "@/components/add-vehicle-component.vue";

onBeforeMount(() => {
    validateLogin()
})
</script>

<template>
    <div>
        <h1>Fahrzeuge verwalten</h1>
        <MaintenanceEditComponent class="pt-3 container w-75 d-flex justify-content-center align-items-center flex-column"/>
        <AddVehicleComponent />
    </div>
</template>