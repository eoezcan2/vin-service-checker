<script setup>
</script>

<template>
    <!-- centered action -->
    <div class="add-vehicle-wrap">
      <router-link class="btn add-vehicle-btn" to="/addvehicle">+ Neues Fahrzeug</router-link>
    </div>
</template>

<style scoped>
.add-vehicle-wrap {
  display: flex;
  justify-content: center;
  margin-top: 1rem;
}

.add-vehicle-btn {
  background: linear-gradient(90deg,#0d6efd,#0b5ed7);
  color: #fff;
  border: none;
  padding: 0.45rem 1rem;
  border-radius: 999px;
  font-weight: 600;
  box-shadow: 0 8px 20px rgba(11,94,215,0.12);
}

.add-vehicle-btn:hover {
  transform: translateY(-2px);
  filter: brightness(0.98);
}
</style>