<script setup>
import axios from 'axios';
import { onMounted, ref } from 'vue';
import MaintenanceComponent from "@/components/maintenance-component.vue";
import VehiclecardComponent from "@/components/vehiclecard-component.vue";
import {safeRequest} from "@/api";

let data = ref([])
let loaded = ref(false)

onMounted(() => {
  safeRequest('api/vin/list', 'GET', {})
      .then(response => {
        console.log(response)
        data.value = response.data
        loaded.value = true
      }).catch(error => {
        console.log(error)
      })
});
</script>

<template>
    <div v-if="loaded">
      <div v-for="i in data.length" v-bind:key="i">
        <div class="bg-dark rounded-2 mt-4">
          <VehiclecardComponent :vin="data[i-1]" class="py-3"/>
          <MaintenanceComponent :vin="data[i-1]" edit class="pt-3"/>
        </div>
      </div>
    </div>
</template>