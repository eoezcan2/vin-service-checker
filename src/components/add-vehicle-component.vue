<script setup>
import { useRouter } from 'vue-router';

const router = useRouter();

function navigateToAddVehicle() {
    // Scroll to top before navigating
    window.scrollTo({ top: 0, behavior: 'smooth' });
    
    // Navigate to add vehicle page
    router.push('/addvehicle');
}
</script>

<template>
    <!-- centered action -->
    <div class="add-vehicle-wrap">
      <button class="btn add-vehicle-btn" @click="navigateToAddVehicle">+ Neues Fahrzeug</button>
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
  cursor: pointer;
  transition: all 0.3s ease;
}

.add-vehicle-btn:hover {
  transform: translateY(-2px);
  filter: brightness(0.98);
  box-shadow: 0 10px 25px rgba(11,94,215,0.2);
}
</style>