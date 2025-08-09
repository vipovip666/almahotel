import { createI18n } from 'vue-i18n'
import zh from './zh.json'
import en from './en.json'

const getDefaultLocale = () => {
  try {
    // @ts-ignore
    const sys = uni.getSystemInfoSync?.()
    const lang = (sys?.language || 'zh').toLowerCase()
    return lang.startsWith('zh') ? 'zh' : 'en'
  } catch {
    return 'zh'
  }
}

export const i18n = createI18n({
  legacy: false,
  locale: getDefaultLocale(),
  fallbackLocale: 'en',
  messages: { zh, en },
})

export const t = (key: string, args?: Record<string, unknown>) => (i18n.global as any).t(key, args)