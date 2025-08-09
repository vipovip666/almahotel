<script setup lang="ts">
import { t } from '@/i18n'
import { ref, onMounted } from 'vue'
import { onLoad } from '@dcloudio/uni-app'

const kw = ref('')
const list = ref(Array.from({ length: 8 }).map((_, i) => ({ id: i+1, name: `Hotel ${i+1}`, price: 299 + i*30, star: 4 })))

onLoad((query) => { kw.value = decodeURIComponent((query?.kw as string) || '') })

const openFilter = () => { uni.showActionSheet({ itemList: [t('search.price'), t('search.star'), t('search.amenities')] }) }
const toDetail = (id: number) => uni.navigateTo({ url: `/pages/hotel/detail?id=${id}` })
</script>

<template>
  <view class="page">
    <u-sticky>
      <view class="filter-bar card">
        <view class="kw">{{ kw }}</view>
        <u-button size="small" @click="openFilter">{{ t('search.filter') }}</u-button>
      </view>
    </u-sticky>

    <view class="list">
      <view class="item card" v-for="h in list" :key="h.id" @click="toDetail(h.id)">
        <image class="thumb" :src="`https://picsum.photos/seed/h${h.id}/600/400`" mode="aspectFill" />
        <view class="meta">
          <view class="name">{{ h.name }}</view>
          <view class="sub">⭐⭐⭐⭐☆</view>
          <view class="price">¥{{ h.price }}/晚</view>
        </view>
      </view>
    </view>
  </view>
</template>

<style scoped lang="scss">
.page { padding: 16rpx; }
.filter-bar { display: flex; align-items: center; justify-content: space-between; padding: 12rpx 16rpx; }
.kw { color: #86909c; }
.item { display: flex; gap: 16rpx; margin-top: 16rpx; overflow: hidden; }
.thumb { width: 240rpx; height: 180rpx; border-top-left-radius: 16rpx; border-bottom-left-radius: 16rpx; }
.meta { flex: 1; padding: 8rpx 4rpx; display: flex; flex-direction: column; justify-content: space-between; }
.name { font-size: 30rpx; font-weight: 600; }
.sub { color: #99a1aa; }
.price { color: #2F6BFF; font-weight: 600; text-align: right; }
</style>