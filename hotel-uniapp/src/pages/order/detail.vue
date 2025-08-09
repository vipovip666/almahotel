<script setup lang="ts">
import { onLoad } from '@dcloudio/uni-app'
import { ref } from 'vue'

const id = ref<number>(0)

onLoad((q) => { id.value = Number(q?.id || 0) })
</script>

<template>
  <view class="page">
    <view class="card block">
      <view class="title">订单 #{{ id }}</view>
      <view class="line">状态：已支付</view>
      <view class="line">入住：2025-08-20</view>
      <view class="line">退房：2025-08-21</view>
      <view class="line">金额：¥599</view>
    </view>
    <view class="card block">
      <u-button type="error">申请退款</u-button>
    </view>
  </view>
</template>

<style scoped lang="scss">
.block { margin: 16rpx; padding: 16rpx; }
.title { font-size: 32rpx; font-weight: 700; margin-bottom: 8rpx; }
.line { margin: 6rpx 0; color: #4e5969; }
</style>