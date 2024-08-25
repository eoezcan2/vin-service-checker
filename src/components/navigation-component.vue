<script setup>
</script>

<template>
    <nav>
        <router-link to="/">Home</router-link> |
        <router-link to="/about">About</router-link> |
        <router-link to="/login">Login</router-link>
    </nav>
</template>

<style scoped>
    nav {
        margin-bottom: 20px;
        padding: 10px;
        background-color: #f0f0f0;
    }

    a {
        text-decoration: none;
        color: #000;
    }

    a:hover {
        text-decoration: underline;
    }

    a:active {
        color: #ff0000;
    }
</style>