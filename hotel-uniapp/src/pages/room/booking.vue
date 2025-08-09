<script setup lang="ts">
import { useBookingStore } from '@/stores/booking'
import { onLoad } from '@dcloudio/uni-app'
import { computed, ref } from 'vue'
import { t } from '@/i18n'

const store = useBookingStore()
const loading = ref(false)

onLoad((q) => {
  store.setRoom(Number(q?.hotelId), Number(q?.roomTypeId), Number(q?.ratePlanId))
})

const canSubmit = computed(() => store.isValid && !loading.value)

const submit = async () => {
  loading.value = true
  try {
    await store.createBooking({ idempotencyKey: (Math.random().toString(36).slice(2) + Date.now()) })
    uni.showToast({ title: '订单已创建，前往支付', icon: 'success' })
  } catch (e: any) {
    uni.showToast({ title: e?.message || '下单失败', icon: 'none' })
  } finally {
    loading.value = false
  }
}
</script>

<template>
  <view class="page">
    <view class="card block">
      <view class="label">{{ t('booking.contact') }}</view>
      <u-input v-model="store.form.contactName" placeholder="John Doe" />
      <u-input v-model="store.form.contactPhone" type="number" :placeholder="t('booking.contactPhone')" />
    </view>

    <view class="card block">
      <view class="label">{{ t('booking.coupon') }}</view>
      <u-input v-model="store.form.couponCode" placeholder="SUMMER50" />
    </view>

    <view class="footer">
      <u-button type="primary" :disabled="!canSubmit" :loading="loading" @click="submit">{{ t('booking.payNow') }}</u-button>
    </view>
  </view>
</template>

<style scoped lang="scss">
.block { margin: 16rpx; padding: 16rpx; }
.label { font-weight: 600; margin-bottom: 12rpx; }
.footer { position: fixed; left: 0; right: 0; bottom: 0; padding: 16rpx; background: #fff; box-shadow: 0 -8rpx 24rpx rgba(0,0,0,.06); }
</style>