export const storage = {
  get<T>(key: string, def?: T): T | undefined {
    try { const v = uni.getStorageSync(key); return v ? JSON.parse(v) as T : def } catch { return def }
  },
  set(key: string, value: any) { try { uni.setStorageSync(key, JSON.stringify(value)) } catch {} },
  remove(key: string) { try { uni.removeStorageSync(key) } catch {} },
}