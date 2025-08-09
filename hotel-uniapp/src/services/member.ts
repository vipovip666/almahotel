import { httpRequest } from '@/services/http'

export const MemberApi = {
  me: () => httpRequest({ url: '/me', method: 'GET' }),
  points: () => httpRequest({ url: '/points/ledger', method: 'GET' }),
  coupons: () => httpRequest({ url: '/coupons/available', method: 'GET' }),
}