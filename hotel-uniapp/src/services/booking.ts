import { httpRequest } from '@/services/http'

export const BookingApi = {
  price: (data: any) => httpRequest({ url: '/bookings/price', method: 'POST', data }),
  create: (data: any, idem: string) => httpRequest({ url: '/bookings', method: 'POST', data, headers: { 'Idempotency-Key': idem } }),
  detail: (id: number) => httpRequest({ url: `/bookings/${id}`, method: 'GET' }),
  cancel: (id: number) => httpRequest({ url: `/bookings/${id}/cancel`, method: 'POST' }),
}