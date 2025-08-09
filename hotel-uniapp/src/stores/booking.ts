import { defineStore } from 'pinia'
import { httpRequest } from '@/services/http'

interface BookingForm {
  hotelId: number | null
  roomTypeId: number | null
  ratePlanId: number | null
  checkin: string
  checkout: string
  contactName: string
  contactPhone: string
  couponCode?: string
  pointsUsed?: number
}

interface BookingState {
  form: BookingForm
  orderId: number | null
}

export const useBookingStore = defineStore('booking', {
  state: (): BookingState => ({
    form: {
      hotelId: null,
      roomTypeId: null,
      ratePlanId: null,
      checkin: '',
      checkout: '',
      contactName: '',
      contactPhone: '',
    },
    orderId: null,
  }),
  getters: {
    isValid: (state) => !!(state.form.hotelId && state.form.roomTypeId && state.form.ratePlanId && state.form.checkin && state.form.checkout && state.form.contactName && state.form.contactPhone),
  },
  actions: {
    setDates(checkin: string, checkout: string) { this.form.checkin = checkin; this.form.checkout = checkout },
    setContact(name: string, phone: string) { this.form.contactName = name; this.form.contactPhone = phone },
    setRoom(hotelId: number, roomTypeId: number, ratePlanId: number) { this.form.hotelId = hotelId; this.form.roomTypeId = roomTypeId; this.form.ratePlanId = ratePlanId },
    async priceOrder() {
      const res = await httpRequest({ url: '/bookings/price', method: 'POST', data: this.form })
      return res
    },
    async createBooking(payload: { idempotencyKey: string }) {
      const res = await httpRequest({ url: '/bookings', method: 'POST', data: { ...this.form }, headers: { 'Idempotency-Key': payload.idempotencyKey } })
      this.orderId = (res as any).id
      return res
    },
  },
})