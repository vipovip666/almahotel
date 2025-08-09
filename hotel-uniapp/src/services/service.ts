import { httpRequest } from '@/services/http'

export const ServiceApi = {
  catalog: () => httpRequest({ url: '/services', method: 'GET' }),
  create: (data: any) => httpRequest({ url: '/services/requests', method: 'POST', data }),
  detail: (id: number) => httpRequest({ url: `/services/requests/${id}`, method: 'GET' }),
}