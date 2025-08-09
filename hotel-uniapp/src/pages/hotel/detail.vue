<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { t } from '@/i18n'
import { onLoad } from '@dcloudio/uni-app'

const id = ref<number>(0)
const rooms = ref(Array.from({ length: 4 }).map((_, i) => ({ id: i+1, name: `高级大床房 ${i+1}`, price: 388 + i*40, planId: i+100 })))

onLoad((q) => { id.value = Number(q?.id || 0) })

const book = (roomId: number, planId: number) => {
  uni.navigateTo({ url: `/pages/room/booking?hotelId=${id.value}&roomTypeId=${roomId}&ratePlanId=${planId}` })
}
</script>

<template>
  <view class="page">
    <swiper class="gallery" circular autoplay>
      <swiper-item v-for="n in 5" :key="n"><image :src="`https://picsum.photos/seed/d${n}/1200/800`" mode="aspectFill" /></swiper-item>
    </swiper>

    <view class="block card">
      <view class="name">Hotel {{ id }}</view>
      <view class="addr text-muted">XX Road, City · 1.2km</view>
    </view>

    <view class="block card">
      <view class="section-title">房型</view>
      <view class="room" v-for="r in rooms" :key="r.id">
        <view class="info">
          <view class="name">{{ r.name }}</view>
          <view class="tags">可退 · 含早</view>
        </view>
        <view class="price">¥{{ r.price }}</view>
        <u-button type="primary" size="small" @click="book(r.id, r.planId)">预订</u-button>
      </view>
    </view>
  </view>
</template>

<style scoped lang="scss">
.page { }
.gallery { height: 420rpx; }
.gallery image { width: 100%; height: 100%; }
.block { margin: 16rpx; padding: 16rpx; }
.name { font-size: 34rpx; font-weight: 600; }
.section-title { font-size: 30rpx; font-weight: 600; margin-bottom: 12rpx; }
.room { display: grid; grid-template-columns: 1fr auto auto; align-items: center; gap: 12rpx; padding: 12rpx 0; }
.tags { color: #86909c; font-size: 24rpx; margin-top: 6rpx; }
.price { color: #2F6BFF; font-weight: 700; }
</style>