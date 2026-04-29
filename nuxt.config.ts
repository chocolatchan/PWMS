// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  compatibilityDate: '2024-11-01',
  devtools: { enabled: true },
  modules: ['@nuxt/ui'],
  css: ['~/assets/css/main.css'],
  ssr: false,
  devServer: {
    port: 1420,
    host: '0.0.0.0',
    strictPort: true
  },
  vite: {
    clearScreen: false,
    server: {
      watch: {
        ignored: ["**/src-tauri/**"]
      }
    }
  },
  future: {
    compatibilityVersion: 4
  }
})
