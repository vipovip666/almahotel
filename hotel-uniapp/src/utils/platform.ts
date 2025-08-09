export type AuthStrategy = 'weixin' | 'alipay' | 'h5' | 'app'

export const getAuthStrategy = (): AuthStrategy => {
  // #ifdef MP-WEIXIN
  return 'weixin'
  // #endif
  // #ifdef MP-ALIPAY
  return 'alipay'
  // #endif
  // #ifdef H5
  return 'h5'
  // #endif
  // #ifdef APP-PLUS
  return 'app'
  // #endif
  return 'h5'
}