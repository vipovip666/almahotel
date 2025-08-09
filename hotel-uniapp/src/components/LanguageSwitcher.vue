<script setup lang="ts">
import { i18n } from '@/i18n'
import { useAuthStore } from '@/stores/auth'
import { ref } from 'vue'

const auth = useAuthStore()
const visible = ref(false)

const toggle = () => (visible.value = !visible.value)
const switchTo = (lang: 'zh' | 'en') => {
  // @ts-ignore
  i18n.global.locale.value = lang
  auth.setLocale(lang)
  visible.value = false
}
</script>

<template>
  <view class="lang-switch" @click.stop="toggle">
    <text>{{ (i18n.global as any).locale.value.toUpperCase() }}</text>
    <view v-if="visible" class="lang-pop">
      <view class="item" @click.stop="switchTo('zh')">中文</view>
      <view class="item" @click.stop="switchTo('en')">English</view>
    </view>
  </view>
</template>

<style scoped lang="scss">
.lang-switch {
  position: fixed;
  right: 24rpx;
  bottom: 160rpx;
  background: #fff;
  padding: 12rpx 16rpx;
  border-radius: 24rpx;
  box-shadow: 0 8rpx 24rpx rgba(0,0,0,.08);
  z-index: 999;
}
.lang-pop {
  position: absolute;
  right: 0;
  bottom: 64rpx;
  background: #fff;
  border-radius: 16rpx;
  box-shadow: 0 8rpx 24rpx rgba(0,0,0,.1);
  .item { padding: 16rpx 24rpx; }
}
</style>