import { AppConfig } from '@/config'
import { useAuthStore } from '@/stores/auth'

type HttpMethod = 'GET' | 'POST' | 'PUT' | 'DELETE' | 'PATCH'

interface RequestOptions<T> {
  url: string
  method?: HttpMethod
  data?: T
  headers?: Record<string, string>
}

export interface ApiResponse<D> { code: number; message: string; data: D; requestId?: string }

export const httpRequest = async <TReq = any, TRes = any>(options: RequestOptions<TReq>): Promise<TRes> => {
  const auth = useAuthStore?.()
  const token = auth?.token || ''

  const [err, res] = await uni.request({
    url: options.url.startsWith('http') ? options.url : `${AppConfig.apiBaseUrl}${options.url}`,
    method: (options.method || 'GET') as any,
    data: options.data || {},
    timeout: AppConfig.requestTimeoutMs,
    header: {
      'Content-Type': 'application/json',
      'Accept-Language': auth?.locale || 'zh',
      'Authorization': token ? `Bearer ${token}` : '',
      ...options.headers,
    },
  }) as unknown as [any, UniApp.RequestSuccessCallbackResult]

  if (err) { throw err }
  const body = res.data as ApiResponse<TRes>
  if (body && typeof body === 'object' && 'code' in body) {
    if ((body as any).code === 0) return body.data as TRes
    throw new Error((body as any).message || 'Request failed')
  }
  // 兼容非标准后端
  return body as any
}