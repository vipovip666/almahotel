<script setup lang="ts">
import { t } from '@/i18n'
import { ref } from 'vue'
import { onShow } from '@dcloudio/uni-app'

const keyword = ref('')
const checkin = ref('')
const checkout = ref('')

onShow(() => {
  // 初始化默认日期：今天与明天
  const today = new Date()
  const tomorrow = new Date(Date.now() + 86400000)
  checkin.value = today.toISOString().slice(0, 10)
  checkout.value = tomorrow.toISOString().slice(0, 10)
})

const goSearch = () => {
  uni.navigateTo({ url: `/pages/search/index?kw=${encodeURIComponent(keyword.value)}&checkin=${checkin.value}&checkout=${checkout.value}` })
}
</script>

<template>
  <view class="page">
    <view class="hero card">
      <view class="title">{{ t('home.title') }}</view>
      <u-input v-model="keyword" :placeholder="t('home.searchPlaceholder')" clearable />
      <view class="date-row">
        <u-input v-model="checkin" type="text" :placeholder="t('home.checkin')" />
        <text class="sep">→</text>
        <u-input v-model="checkout" type="text" :placeholder="t('home.checkout')" />
      </view>
      <u-button type="primary" class="cta" @click="goSearch">{{ t('home.search') }}</u-button>
    </view>

    <view class="section">
      <view class="section-title">{{ t('home.hotDestinations') }}</view>
      <scroll-view scroll-x class="scroll">
        <view class="pill" v-for="n in 8" :key="n">City {{ n }}</view>
      </scroll-view>
    </view>

    <view class="section">
      <view class="section-title">{{ t('home.forYou') }}</view>
      <view class="grid">
        <view class="hotel-card card" v-for="n in 6" :key="n" @click="goSearch">
          <image class="cover" src="https://picsum.photos/seed/hotel{{n}}/600/400" mode="aspectFill" />
          <view class="info">
            <view class="name">Hotel {{ n }}</view>
            <view class="price">¥{{ 299 + n * 20 }}/晚</view>
          </view>
        </view>
      </view>
    </view>
  </view>
</template>

<style scoped lang="scss">
.page { padding: 24rpx; }
.hero { padding: 24rpx; }
.title { font-size: 36rpx; font-weight: 600; margin-bottom: 16rpx; }
.date-row { display: flex; align-items: center; gap: 12rpx; margin-top: 12rpx; }
.sep { color: #999; }
.cta { margin-top: 16rpx; }
.section { margin-top: 24rpx; }
.section-title { font-size: 30rpx; font-weight: 600; margin-bottom: 12rpx; }
.scroll { white-space: nowrap; }
.pill { display: inline-block; padding: 12rpx 20rpx; background: #fff; border-radius: 999rpx; margin-right: 12rpx; box-shadow: 0 4rpx 12rpx rgba(0,0,0,.06); }
.grid { display: grid; grid-template-columns: repeat(2, 1fr); gap: 16rpx; }
.hotel-card { overflow: hidden; }
.cover { width: 100%; height: 240rpx; border-top-left-radius: 16rpx; border-top-right-radius: 16rpx; }
.info { padding: 12rpx; display: flex; justify-content: space-between; align-items: center; }
.name { font-size: 28rpx; }
.price { color: #2F6BFF; font-weight: 600; }
</style>