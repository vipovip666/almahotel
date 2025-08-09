# API 文档（REST）

统一返回：
```json
{ "code": 0, "message": "ok", "data": {}, "requestId": "..." }
```

通用 Header：
- Authorization: Bearer <JWT>
- Accept-Language: zh|en
- X-Currency: CNY|USD
- Idempotency-Key: <uuid> （写操作必须）

## 鉴权与登录
- POST /auth/mp/weixin
  - body: { code }
  - resp: { token, user }
- POST /auth/mp/alipay
  - body: { code }
  - resp: { token, user }
- POST /auth/otp/send
  - body: { phone, countryCode }
- POST /auth/otp/login
  - body: { phone, code }
  - resp: { token, user }

## 配置
- GET /config/app -> { payments: [...], currencies: [...], exchangeVersion, cms: {...} }

## 酒店搜索
- GET /hotels/search
  - query: q, checkin, checkout, city, lat, lng, radius, priceMin, priceMax, stars, ratingMin, amenities[], sort
  - resp: { list: [{ id, name, star, minPrice, rating, distance, cover }], page, pageSize, total }
- GET /hotels/{id}
  - resp: { id, name, description, photos: [], star, rating, address, geo, amenities: [], i18n: {...} }
- GET /hotels/{id}/rooms
  - query: checkin, checkout, adults
  - resp: [ { roomTypeId, name, area, bed, images: [], ratePlans: [ { ratePlanId, priceCents, currency, cancelPolicy, mealPlan } ] } ]

## 预订
- POST /bookings/price
  - body: { hotelId, roomTypeId, ratePlanId, checkin, checkout, couponCode?, pointsUsed? }
  - resp: { totalAmountCents, currency, breakdown: { room: [], tax: [], serviceFee: [] } }
- POST /bookings
  - headers: Idempotency-Key
  - body: { hotelId, roomTypeId, ratePlanId, checkin, checkout, contactName, contactPhone, couponCode?, pointsUsed? }
  - resp: { id, status: 'PENDING', payParams?: {...} }
- GET /bookings/{id}
- POST /bookings/{id}/cancel
- POST /bookings/{id}/refund

## 支付
- POST /payments/{bookingId}/pay
  - body: { provider, channel }
  - resp: { invokeParams }
- POST /payments/{paymentId}/close
- POST /payments/webhook/{provider}

## 会员与积分
- GET /me -> { user, member: { tier, points, benefits } }
- GET /points/ledger -> { list, total }
- GET /coupons/available -> { list }
- POST /coupons/redeem -> { success }

## 在线客房服务
- GET /services -> { categories: [...] }
- POST /services/requests -> { id }
- GET /services/requests/{id} -> { id, status }

## 评价
- POST /reviews
- GET /reviews/mine
- GET /hotels/{id}/reviews

## 错误码
- 40001 参数校验失败
- 40002 库存不足
- 40003 取消政策不允许
- 40101 未登录
- 40201 支付失败
- 40901 幂等冲突