<script setup>
    import VinSearch from '../vin-search.vue'
</script>

<template>
    <!-- changed: add center-viewport to vertically center header and searchbar -->
    <div class="center-viewport text-center">
        <h2><span class="typing-header"><img src="/coolcar.png" alt="CoolCar" width="50" height="50" class="me-2"/>Finde das Servicebuch deines Fahrzeuges.</span></h2>
        <VinSearch class="pt-3"/>
    </div>
</template>

<style scoped>
/* new: center content vertically and horizontally, account for fixed navbar height (~100px)
   small upward nudge added with translateY(-6%) to move a little bit more up */
.center-viewport {
  min-height: calc(100vh - 250px);
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  transform: translateY(-6%);
}

/* new: typing animation for header */
.typing-header {
  display: inline-block;
  overflow: hidden;
  white-space: nowrap;
  border-right: .12em solid rgba(0,0,0,0.75);
  /*font-family: "Courier New", Courier, monospace;*/
  font-weight: 600;
  font-size: 1.5rem;
  animation: typing 2.25s steps(36,end), blink-caret .75s step-end infinite;
  /* ensure the element can shrink/expand smoothly */
  width: auto;
}

/* slightly faster on small screens and smaller font */
@media (max-width: 576px) {
  .typing-header {
    font-size: 1.2rem;
    animation-duration: 3s;
  }
}

@keyframes typing {
  from { width: 0; }
  to { width: 100%; }
}
@keyframes blink-caret {
  from, to { border-color: transparent; }
  50% { border-color: rgba(0,0,0,0.75); }
}
</style>