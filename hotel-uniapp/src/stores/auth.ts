import { defineStore } from 'pinia'
import { getAuthStrategy } from '@/utils/platform'
import { httpRequest } from '@/services/http'

export interface UserProfile {
  id: number
  display_name: string
  avatar_url?: string
  locale?: string
  currency?: string
  member_tier_id?: number
}

interface AuthState {
  token: string
  user: UserProfile | null
  locale: 'zh' | 'en'
}

export const useAuthStore = defineStore('auth', {
  state: (): AuthState => ({ token: '', user: null, locale: 'zh' }),
  actions: {
    setToken(token: string) { this.token = token },
    setUser(user: UserProfile | null) { this.user = user },
    setLocale(locale: 'zh' | 'en') { this.locale = locale },
    async loginWithPlatform() {
      const strategy = getAuthStrategy()
      if (strategy === 'weixin') {
        const res = await uni.login({ provider: 'weixin' })
        const code = (res as any)[1]?.code
        const data = await httpRequest<{ code: string }, { token: string; user: UserProfile }>({ url: '/auth/mp/weixin', method: 'POST', data: { code } })
        this.token = data.token
        this.user = data.user
      } else if (strategy === 'alipay') {
        const res = await uni.login({ provider: 'alipay' })
        const code = (res as any)[1]?.code
        const data = await httpRequest<{ code: string }, { token: string; user: UserProfile }>({ url: '/auth/mp/alipay', method: 'POST', data: { code } })
        this.token = data.token
        this.user = data.user
      }
    },
    async loginWithPhone(phone: string, code: string) {
      const data = await httpRequest<{ phone: string; code: string }, { token: string; user: UserProfile }>({ url: '/auth/otp/login', method: 'POST', data: { phone, code } })
      this.token = data.token
      this.user = data.user
    },
    logout() { this.token = ''; this.user = null },
  },
})