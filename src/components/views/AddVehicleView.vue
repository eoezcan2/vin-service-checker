<script setup>
import {validateLogin} from "@/api";
import {onBeforeMount} from "vue";

onBeforeMount(() => {
  validateLogin()
})
</script>

<template>
    <div>
        <h1>Fahrzeug hinzufügen</h1>
    </div>
</template>

<style scoped>

</style>