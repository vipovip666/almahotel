<script setup lang="ts">
import { onLoad } from '@dcloudio/uni-app'
import { ref } from 'vue'

const type = ref('CLEANING')
const note = ref('')

onLoad((q) => { type.value = (q?.type as string) || 'CLEANING' })

const submit = () => {
  uni.showToast({ title: '已提交', icon: 'success' })
}
</script>

<template>
  <view class="page">
    <view class="card block">
      <view class="label">服务类型</view>
      <u-input :value="type" disabled />
    </view>
    <view class="card block">
      <view class="label">备注</view>
      <u-textarea v-model="note" placeholder="请填写具体需求" />
    </view>
    <view class="footer">
      <u-button type="primary" @click="submit">提交请求</u-button>
    </view>
  </view>
</template>

<style scoped lang="scss">
.block { margin: 16rpx; padding: 16rpx; }
.label { font-weight: 600; margin-bottom: 12rpx; }
.footer { position: fixed; left: 0; right: 0; bottom: 0; padding: 16rpx; background: #fff; box-shadow: 0 -8rpx 24rpx rgba(0,0,0,.06); }
</style>