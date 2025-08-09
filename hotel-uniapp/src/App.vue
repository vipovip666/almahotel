<script setup lang="ts">
import LanguageSwitcher from '@/components/LanguageSwitcher.vue'
</script>

<template>
  <view class="app-root">
    <slot />
    <LanguageSwitcher />
  </view>
</template>

<style lang="scss">
.app-root {
  min-height: 100vh;
  background: #f6f7fb;
}
</style>