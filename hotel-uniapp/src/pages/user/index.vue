<script setup lang="ts">
import { useAuthStore } from '@/stores/auth'
import { t } from '@/i18n'

const auth = useAuthStore()

const login = async () => {
  try {
    await auth.loginWithPlatform()
  } catch (e) {
    // Fallback：H5/APP 请跳转到手机号登录
    uni.navigateTo({ url: '/pages/auth/login' })
  }
}
</script>

<template>
  <view class="page">
    <view class="card header">
      <image class="avatar" :src="auth.user?.avatar_url || 'https://i.pravatar.cc/200'" />
      <view class="info">
        <view class="name">{{ auth.user?.display_name || t('account.login') }}</view>
        <view class="sub">{{ auth.user?.currency || 'CNY' }}</view>
      </view>
      <u-button v-if="!auth.token" size="small" type="primary" @click="login">{{ t('account.login') }}</u-button>
      <u-button v-else size="small" type="warning" @click="auth.logout">{{ t('account.logout') }}</u-button>
    </view>

    <u-cell-group>
      <u-cell title="优惠券" isLink></u-cell>
      <u-cell title="积分" isLink></u-cell>
      <u-cell title="常用旅客" isLink></u-cell>
      <u-cell title="发票抬头" isLink></u-cell>
    </u-cell-group>
  </view>
</template>

<style scoped lang="scss">
.page { padding: 16rpx; }
.header { display: flex; align-items: center; gap: 16rpx; padding: 16rpx; }
.avatar { width: 96rpx; height: 96rpx; border-radius: 50%; }
.name { font-size: 30rpx; font-weight: 600; }
.sub { color: #86909c; }
</style>