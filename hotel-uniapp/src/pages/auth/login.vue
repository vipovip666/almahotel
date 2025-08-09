<script setup lang="ts">
import { ref } from 'vue'
import { useAuthStore } from '@/stores/auth'

const auth = useAuthStore()
const phone = ref('')
const code = ref('')
const sending = ref(false)

const sendCode = async () => {
  sending.value = true
  try {
    await uni.request({ url: 'https://api.example.com/auth/otp/send', method: 'POST', data: { phone: phone.value, countryCode: '+86' } })
    uni.showToast({ title: '验证码已发送' })
  } finally {
    sending.value = false
  }
}

const login = async () => {
  try {
    await auth.loginWithPhone(phone.value, code.value)
    uni.navigateBack()
  } catch (e: any) {
    uni.showToast({ title: e?.message || '登录失败', icon: 'none' })
  }
}
</script>

<template>
  <view class="page">
    <view class="card block">
      <u-input v-model="phone" placeholder="手机号" type="number" />
      <view class="row">
        <u-input v-model="code" placeholder="验证码" />
        <u-button size="small" @click="sendCode" :loading="sending">发送</u-button>
      </view>
    </view>
    <view class="footer">
      <u-button type="primary" @click="login">登录</u-button>
    </view>
  </view>
</template>

<style scoped lang="scss">
.block { margin: 16rpx; padding: 16rpx; }
.row { display: grid; grid-template-columns: 1fr auto; gap: 12rpx; margin-top: 12rpx; }
.footer { position: fixed; left: 0; right: 0; bottom: 0; padding: 16rpx; background: #fff; box-shadow: 0 -8rpx 24rpx rgba(0,0,0,.06); }
</style>