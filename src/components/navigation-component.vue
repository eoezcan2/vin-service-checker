<script setup>
import { isTokenPresent, logout } from '@/api';
import { watch } from 'vue';

watch(isTokenPresent, async () => {
    console.log('Token present:', isTokenPresent);
});
</script>

<template>
    <nav class="navbar bg-dark navbar-expand-lg px-2 fixed-top">
      <div class="container-fluid">
        <router-link class="navbar-brand text-light" to="/">Service Checker</router-link>
        <button class="navbar-toggler bg-light" type="button" data-bs-toggle="collapse" data-bs-target="#navbarText" aria-controls="navbarText" aria-expanded="false" aria-label="Toggle navigation">
          <span class="navbar-toggler-icon bg-light"></span>
        </button>
        <div class="collapse navbar-collapse text-light" id="navbarText">
          <ul class="navbar-nav me-auto mb-2 mb-lg-0 bg-dark">
            <li class="nav-item">
              <router-link class="nav-link text-light" to="/about">Über uns</router-link>
            </li>
          </ul>
          <span class="navbar-text">
            <router-link class="btn btn-dark text-light" to="/login" v-if="!isTokenPresent">Login</router-link>
            <span v-else>
              <router-link class="me-3" to="/account" >
                <img src="/avatar.svg" alt="avatar" width="20" height="20">
              </router-link>
              <a class="btn btn-dark text-light" href="#" @click="logout">Ausloggen</a>
            </span>
          </span>
        </div>
      </div>
    </nav>
</template>

<style scoped>
</style>