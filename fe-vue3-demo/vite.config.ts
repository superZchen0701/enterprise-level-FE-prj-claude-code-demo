import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import { fileURLToPath, URL } from 'node:url'

export default defineConfig({
  plugins: [vue()],
  resolve: {
    alias: {
      '@': fileURLToPath(new URL('./src', import.meta.url)),
      '@docs': fileURLToPath(new URL('./docs', import.meta.url))
    }
  },
  server: {
    port: 8082,
    open: true
  },
  build: {
    sourcemap: false
  }
})