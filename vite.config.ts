import { defineConfig } from 'vite';
import solidPlugin from 'vite-plugin-solid';
import { viteSingleFile } from 'vite-plugin-singlefile';
import { resolve } from 'path';

export default defineConfig({
  plugins: [solidPlugin(), viteSingleFile()],
  root: resolve(__dirname, 'snake'),
  base: './',
  build: {
    outDir: resolve(__dirname, 'build'),
    emptyOutDir: true,
    target: 'esnext',
    assetsInlineLimit: 100000000,
    cssCodeSplit: false,
    rollupOptions: {
      input: {
        main: resolve(__dirname, 'snake/snake.html')
      }
    }
  }
});
