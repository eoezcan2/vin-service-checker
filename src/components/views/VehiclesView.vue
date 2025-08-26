<script setup>
import MaintenanceEditComponent from '../maintenance-edit-component.vue';
import AddVehicleComponent from "@/components/add-vehicle-component.vue";

</script>

<template>
    <div class="account-page container d-flex flex-column align-items-center">
        <!-- <h1 class="account-title">Fahrzeuge verwalten</h1> -->
        <div class="w-100 d-flex flex-column align-items-center">
          <MaintenanceEditComponent class="pt-3" />
          <AddVehicleComponent />
        </div>
    </div>
</template>

<style scoped>
.account-page {
  padding-top: 1rem;
  padding-bottom: 2.5rem;
}

.account-title {
  font-weight: 700;
  margin-bottom: 0.75rem;
  text-align: center;
}

/* ensure the maintenance component area doesn't stretch too wide */
.account-page > .w-100 {
  max-width: 1100px;
}
</style>