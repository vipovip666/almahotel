<script setup lang="ts">
import { t } from '@/i18n'
import { ref } from 'vue'

const orders = ref(Array.from({ length: 5 }).map((_, i) => ({ id: i+1, title: `Hotel ${i+1}`, status: 'PAID', amount: 399 + i*50 })))
const toDetail = (id: number) => uni.navigateTo({ url: `/pages/order/detail?id=${id}` })
</script>

<template>
  <view class="page">
    <view class="title">{{ t('order.myOrders') }}</view>
    <view class="card item" v-for="o in orders" :key="o.id" @click="toDetail(o.id)">
      <view class="left">
        <view class="name">{{ o.title }}</view>
        <view class="status">{{ o.status }}</view>
      </view>
      <view class="right">¥{{ o.amount }}</view>
    </view>
  </view>
</template>

<style scoped lang="scss">
.page { padding: 16rpx; }
.title { font-size: 32rpx; font-weight: 700; margin-bottom: 12rpx; }
.item { display: flex; justify-content: space-between; align-items: center; padding: 16rpx; margin-bottom: 12rpx; }
.status { color: #22C55E; }
.right { color: #2F6BFF; font-weight: 700; }
</style>