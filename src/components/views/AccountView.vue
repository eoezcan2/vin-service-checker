<script setup>
import { isTokenPresent } from '@/api';
import router from '@/router';
import { onMounted } from 'vue';

onMounted(() => {
    if (!isTokenPresent) {
        router.push('/login')
    }
});
</script>

<template>
    <div>
        <h1>Account</h1>
        <p>This is the account page. Here you can see your account details and manage your account.</p>
    </div>
</template>