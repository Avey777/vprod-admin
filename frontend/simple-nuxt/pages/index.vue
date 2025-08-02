<template>
  <NuxtLayout>
    <el-row>
      <el-col :span="12">
        <h1 class="pt-10 text-5xl text-rose-500">Simple Nuxt</h1>
        <el-text size="large" tag="b"> {{ $t("index.intro") }}</el-text>
      </el-col>
      <el-col :span="12" class="grid place-items-center">
        <el-image
          src="/images/logo.svg"
          alt="Logo"
          class="p-10 h-50"
        ></el-image>
      </el-col>
    </el-row>
  </NuxtLayout>
</template>
<script lang="ts" setup></script>
