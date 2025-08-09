import { defineConfig } from 'vite'
import Uni from '@dcloudio/vite-plugin-uni'

const uniPlugin: any = (Uni as any)?.default || (Uni as any)

export default defineConfig({
  plugins: [uniPlugin()],
})