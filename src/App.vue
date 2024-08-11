<script>
import { RouterView } from 'vue-router'

  export default {
    name: 'App',
    components: {
      RouterView
    }
  }
</script>

<template>
  <main>
    <router-view />
  </main>
</template>

<style>
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  margin-top: 60px;
}

input[type="text"] {
  width: 25%;
  height: 1.5rem;
  text-align: center;
}

button {
  border: none;
  border-radius: 5px;
  padding: 10px;
  cursor: pointer;
  background-color: #ff0202;
  color: white;
}
</style>
