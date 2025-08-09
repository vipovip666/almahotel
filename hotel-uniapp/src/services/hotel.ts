import { httpRequest } from '@/services/http'

export const HotelApi = {
  search: (params: Record<string, any>) => httpRequest({ url: '/hotels/search', method: 'GET', data: params }),
  detail: (id: number) => httpRequest({ url: `/hotels/${id}`, method: 'GET' }),
  rooms: (id: number, params: Record<string, any>) => httpRequest({ url: `/hotels/${id}/rooms`, method: 'GET', data: params }),
}