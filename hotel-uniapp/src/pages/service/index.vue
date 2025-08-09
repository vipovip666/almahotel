<script setup lang="ts">
const toRequest = (type: string) => uni.navigateTo({ url: `/pages/service/request?type=${type}` })
</script>

<template>
  <view class="page">
    <view class="grid">
      <view class="card item" @click="toRequest('CLEANING')">客房清洁</view>
      <view class="card item" @click="toRequest('MEAL')">送餐</view>
      <view class="card item" @click="toRequest('ITEM')">物品申请</view>
      <view class="card item" @click="toRequest('WAKEUP')">叫醒服务</view>
    </view>
  </view>
</template>

<style scoped lang="scss">
.page { padding: 16rpx; }
.grid { display: grid; grid-template-columns: repeat(2, 1fr); gap: 16rpx; }
.item { padding: 40rpx 0; text-align: center; font-size: 30rpx; }
</style>