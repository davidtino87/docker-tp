import path from "path"
import react from "@vitejs/plugin-react"
import { defineConfig } from "vite"

// https://vite.dev/config/
export default defineConfig({
  plugins: [react()],
  resolve: {
    alias: {
      "@": path.resolve(__dirname, "./src"),
    },
  },
  server: {
    host: true,                // Nécessaire pour que Docker puisse exposer le port
    watch: {
      usePolling: true,        // Permet de détecter les changements de fichiers dans un volume Docker
    },
    hmr: {
      clientPort: 80,        // Force le navigateur à utiliser ce port pour le rafraîchissement
    },
    proxy: {
      '/api': {
        target: 'http://backend:8000',
        changeOrigin: true,
        rewrite: (path) => path.replace(/^\/api/, ''),
      },
    },
  }
})
