// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  compatibilityDate: "2025-07-15",
  devtools: { enabled: true },
  ssr: false,
  nitro: {
    preset: "static",
  },

  components: [{ path: "~/app/components", prefix: "App" }],
  modules: [
    "@nuxt/content",
    "@nuxt/eslint",
    "@nuxt/image",
    "@nuxt/scripts",
    "@nuxt/test-utils",
    "@nuxt/ui",
    "@pinia/nuxt",
    "nuxt-icon",
    "@nuxtjs/tailwindcss",
  ],
  fonts: {
    providers: {
      google: false,
      googleicons: false,
    },
  },

  // 启用 Vue 兼容性选项
  vue: {
    compilerOptions: {
      isCustomElement: (tag) => tag.includes("fa-icon"), // 更新自定义标签名
    },
  },
});
