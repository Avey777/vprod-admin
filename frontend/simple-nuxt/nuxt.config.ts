// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  devtools: { enabled: true },

  modules: [
    "@unocss/nuxt",
    "@nuxtjs/i18n",
    "@element-plus/nuxt",
    "@nuxtjs/eslint-module",
    "nuxt-icon",
    "@pinia/nuxt",
    "@pinia-plugin-persistedstate/nuxt",
  ],

  i18n: {
    lazy: true,
    langDir: "locales/",
    strategy: "prefix_except_default",
    locales: [
      {
        code: "en-US",
        iso: "en-US",
        name: "English(US)",
        file: "en-US.json",
      },
      {
        code: "zh-CN",
        iso: "zh-CN",
        name: "Chinese",
        file: "zh-CN.json",
      },
    ],
    defaultLocale: "zh-CN",
  },

  eslint: {
    fix: true,
  },

  runtimeConfig: {
    public: {
      baseURL: "http://localhost:9104",
    },
  },

  nitro: {
    routeRules: {
      "/mms-api/**": { proxy: "http://localhost:9104/**" },
      "/cms-api/**": { proxy: "http://localhost:9107/**" },
    },
  },

  compatibilityDate: "2024-11-02",
});
