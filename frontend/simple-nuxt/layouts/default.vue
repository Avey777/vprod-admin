<script lang="ts" setup>
import Header from "~/components/layout/Header.vue";
import Footer from "~/components/layout/Footer.vue";
</script>

<template>
  <div>
    <Header />
    <el-row>
      <el-col :span="20" :offset="2">
        <slot />
      </el-col>
    </el-row>
    <Footer></Footer>
  </div>
</template>

<style scoped></style>
