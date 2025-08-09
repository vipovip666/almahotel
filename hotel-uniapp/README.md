# Hotel Uni-App Platform

A production-ready, internationalized hotel booking platform built with uni-app (Vue 3 + Vite).

## Scripts
- dev: `npm run dev`
- build H5: `npm run build:h5`
- build WeChat MP: `npm run build:mp-weixin`
- build Alipay MP: `npm run build:mp-alipay`

## Features
- Hotel search & filter, booking & payment, membership & points, in-room services, reviews, multi-language (ZH/EN), unified login.

## Structure
- `src/pages`: pages
- `src/components`: reusable components
- `src/stores`: Pinia stores
- `src/services`: API wrappers (`uni.request`)
- `src/i18n`: i18n config and messages
- `src/styles`: design tokens and global styles
- `docs/API.md`: REST API definitions
- `docs/DB.sql`: MySQL schema

## Configure
- Set `VITE_API_BASE_URL` in `.env.*` files.
- Configure `manifest.json` appids for WeChat/Alipay mini programs.