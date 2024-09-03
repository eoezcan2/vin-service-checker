<script>
import { RouterView } from 'vue-router'
import NavigationComponent from './components/navigation-component.vue';
// import HeaderComponent from './components/header-component.vue';

  export default {
    name: 'App',
    components: {
      RouterView,
      NavigationComponent,
      // HeaderComponent
    }
  }
</script>

<template>
  <main>
    <NavigationComponent />
    <!--<HeaderComponent />-->
    <div class="container-fluid mt-5">
      <router-view />
    </div>
  </main>
</template>

<style>
#app {
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
}

/*input[type="text"], input[type="password"] {
  width: 25%;
  min-width: 200px;
  height: 2rem;
  text-align: center;
  font-size: 1rem;
}

button {
  border: none;
  border-radius: 5px;
  padding: 10px;
  cursor: pointer;
  background-color: #4CAF50;
  color: white;
  width: 100px;
}

button:hover {
  background-color: #45a049;
}

button:active {
  background-color: #3e8e41;
}

button:focus {
  outline: none;
}

.danger {
  background-color: #ff0000;
}*/
</style>
