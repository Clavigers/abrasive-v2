import { defineConfig } from 'astro/config';
import mdx from '@astrojs/mdx';

export default defineConfig({
  integrations: [mdx()],
  vite: {
    server: {
      proxy: {
        '/dashboard': {
          target: 'http://localhost:5173',
          changeOrigin: true,
          ws: true,
          rewrite: (path) => path.replace(/^\/dashboard/, '') || '/',
        },
      },
    },
  },
});
