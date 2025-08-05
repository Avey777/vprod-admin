<template>
  <div class="container">
    <Navbar />
    <slot />
    <!-- 页面内容注入点 -->
    <Footer />
  </div>
</template>

<script setup>
import Navbar from "../components/Navbar.vue";
import Footer from "../components/Footer.vue";
</script>
