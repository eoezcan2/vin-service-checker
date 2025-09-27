<script>
import { RouterView } from 'vue-router'
import NavigationComponent from './components/navigation-component.vue';
import FooterComponent from './components/footer-component.vue';
// import HeaderComponent from './components/header-component.vue';

  export default {
    name: 'App',
    components: {
      RouterView,
      NavigationComponent,
      FooterComponent,
      // HeaderComponent
    }
  }
</script>

<template>
  <div class="app-container">
    <NavigationComponent />
    <!--<HeaderComponent />-->
    <main class="main-content">
      <div class="mt-custom">
        <router-view />
      </div>
    </main>
    <FooterComponent />
  </div>
</template>

<style>

.app-container {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
}

.main-content {
  flex: 1;
  display: flex;
  flex-direction: column;
}

.mt-custom {
  margin-top: 100px;
  flex: 1;
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
