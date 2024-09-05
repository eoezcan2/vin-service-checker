<script setup>
import { isTokenPresent } from '@/api';
import router from '@/router';
import { onBeforeMount } from 'vue';
import MaintenanceEditComponent from '../maintenance-edit-component.vue';

onBeforeMount(() => {
    if (!isTokenPresent) {
        router.push('/login')
    } else {
        console.log(localStorage.getItem('token'))
    }
});
</script>

<template>
    <div>
        <h1>Fahrzeuge verwalten</h1>
        <MaintenanceEditComponent class="pt-3 container w-75 d-flex justify-content-center align-items-center flex-column"/>
    </div>
</template>