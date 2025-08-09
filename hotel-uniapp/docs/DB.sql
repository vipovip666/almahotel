-- MySQL schema for Hotel Platform
-- 金额使用分（cents），时间使用 UTC，text 使用 utf8mb4

CREATE TABLE users (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  phone VARCHAR(32) UNIQUE,
  email VARCHAR(128),
  country_code VARCHAR(8),
  display_name VARCHAR(64),
  avatar_url VARCHAR(255),
  locale VARCHAR(8) DEFAULT 'zh',
  currency VARCHAR(8) DEFAULT 'CNY',
  member_tier_id BIGINT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_users_phone (phone)
);

CREATE TABLE auth_identities (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  user_id BIGINT NOT NULL,
  provider ENUM('weixin','alipay','apple','google','phone') NOT NULL,
  open_id VARCHAR(128),
  union_id VARCHAR(128),
  unique_key VARCHAR(255) UNIQUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE hotels (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  brand_id BIGINT,
  star_rating TINYINT,
  latitude DECIMAL(10,7),
  longitude DECIMAL(10,7),
  address VARCHAR(255),
  city_code VARCHAR(32),
  country_code VARCHAR(8),
  phone VARCHAR(64),
  checkin_time VARCHAR(16),
  checkout_time VARCHAR(16),
  status TINYINT DEFAULT 1,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE hotel_i18n (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  hotel_id BIGINT NOT NULL,
  locale VARCHAR(8) NOT NULL,
  name VARCHAR(128) NOT NULL,
  description TEXT,
  address_text VARCHAR(255),
  UNIQUE KEY uk_hotel_locale (hotel_id, locale),
  FOREIGN KEY (hotel_id) REFERENCES hotels(id)
);

CREATE TABLE amenities (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  code VARCHAR(64) UNIQUE,
  icon VARCHAR(128)
);

CREATE TABLE amenity_i18n (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  amenity_id BIGINT NOT NULL,
  locale VARCHAR(8) NOT NULL,
  name VARCHAR(64) NOT NULL,
  UNIQUE KEY uk_amenity_locale (amenity_id, locale),
  FOREIGN KEY (amenity_id) REFERENCES amenities(id)
);

CREATE TABLE hotel_amenities (
  hotel_id BIGINT NOT NULL,
  amenity_id BIGINT NOT NULL,
  PRIMARY KEY (hotel_id, amenity_id)
);

CREATE TABLE room_types (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  hotel_id BIGINT NOT NULL,
  max_adults TINYINT,
  bed_type VARCHAR(32),
  area_sqm DECIMAL(6,2),
  images JSON,
  status TINYINT DEFAULT 1,
  FOREIGN KEY (hotel_id) REFERENCES hotels(id)
);

CREATE TABLE room_type_i18n (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  room_type_id BIGINT NOT NULL,
  locale VARCHAR(8) NOT NULL,
  name VARCHAR(128),
  description TEXT,
  UNIQUE KEY uk_roomtype_locale (room_type_id, locale),
  FOREIGN KEY (room_type_id) REFERENCES room_types(id)
);

CREATE TABLE rate_plans (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  hotel_id BIGINT NOT NULL,
  room_type_id BIGINT NOT NULL,
  code VARCHAR(64),
  meal_plan ENUM('RO','BB','HB','FB') DEFAULT 'RO',
  cancel_policy JSON,
  prepay TINYINT DEFAULT 1,
  status TINYINT DEFAULT 1,
  FOREIGN KEY (hotel_id) REFERENCES hotels(id),
  FOREIGN KEY (room_type_id) REFERENCES room_types(id)
);

CREATE TABLE room_inventory (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  hotel_id BIGINT NOT NULL,
  room_type_id BIGINT NOT NULL,
  date DATE NOT NULL,
  allotment INT NOT NULL,
  sold INT NOT NULL DEFAULT 0,
  price_cents INT NOT NULL,
  currency VARCHAR(8) NOT NULL,
  closed TINYINT DEFAULT 0,
  UNIQUE KEY uk_inv (room_type_id, date),
  FOREIGN KEY (hotel_id) REFERENCES hotels(id),
  FOREIGN KEY (room_type_id) REFERENCES room_types(id)
);

CREATE TABLE bookings (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  user_id BIGINT NOT NULL,
  hotel_id BIGINT NOT NULL,
  checkin DATE NOT NULL,
  checkout DATE NOT NULL,
  nights INT NOT NULL,
  status ENUM('PENDING','PAID','CANCELLED','REFUNDED','NOSHOW','CONSUMED') NOT NULL,
  contact_name VARCHAR(64),
  contact_phone VARCHAR(32),
  total_amount_cents INT NOT NULL,
  currency VARCHAR(8) NOT NULL,
  coupon_id BIGINT,
  points_used INT DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (hotel_id) REFERENCES hotels(id)
);

CREATE TABLE booking_items (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  booking_id BIGINT NOT NULL,
  room_type_id BIGINT NOT NULL,
  rate_plan_id BIGINT NOT NULL,
  date DATE NOT NULL,
  price_cents INT NOT NULL,
  currency VARCHAR(8) NOT NULL,
  FOREIGN KEY (booking_id) REFERENCES bookings(id),
  FOREIGN KEY (room_type_id) REFERENCES room_types(id),
  FOREIGN KEY (rate_plan_id) REFERENCES rate_plans(id)
);

CREATE TABLE payments (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  booking_id BIGINT NOT NULL,
  provider ENUM('weixin','alipay','apple','google','stripe') NOT NULL,
  transaction_no VARCHAR(128),
  status ENUM('INIT','SUCCESS','FAILED','REFUNDING','REFUNDED') NOT NULL,
  amount_cents INT NOT NULL,
  currency VARCHAR(8) NOT NULL,
  idempotency_key VARCHAR(64),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY uk_idem (idempotency_key),
  FOREIGN KEY (booking_id) REFERENCES bookings(id)
);

CREATE TABLE refunds (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  payment_id BIGINT NOT NULL,
  refund_no VARCHAR(128),
  status ENUM('INIT','SUCCESS','FAILED') NOT NULL,
  amount_cents INT NOT NULL,
  reason VARCHAR(255),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (payment_id) REFERENCES payments(id)
);

CREATE TABLE membership_tiers (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  code VARCHAR(32) UNIQUE,
  level INT NOT NULL,
  upgrade_threshold INT NOT NULL,
  benefits JSON
);

CREATE TABLE points_ledger (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  user_id BIGINT NOT NULL,
  delta INT NOT NULL,
  balance INT NOT NULL,
  reason VARCHAR(128),
  related_booking_id BIGINT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE coupons (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  code VARCHAR(64) UNIQUE,
  type ENUM('AMOUNT','PERCENT') NOT NULL,
  value INT NOT NULL,
  min_spend_cents INT DEFAULT 0,
  start_at DATETIME,
  end_at DATETIME,
  status TINYINT DEFAULT 1,
  usage_limit INT DEFAULT 1
);

CREATE TABLE user_coupons (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  user_id BIGINT NOT NULL,
  coupon_id BIGINT NOT NULL,
  used TINYINT DEFAULT 0,
  used_booking_id BIGINT,
  assigned_at DATETIME,
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (coupon_id) REFERENCES coupons(id)
);

CREATE TABLE service_requests (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  booking_id BIGINT NOT NULL,
  type ENUM('CLEANING','MEAL','ITEM','WAKEUP','OTHER') NOT NULL,
  content JSON,
  status ENUM('OPEN','IN_PROGRESS','DONE','CANCELLED') NOT NULL DEFAULT 'OPEN',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (booking_id) REFERENCES bookings(id)
);

CREATE TABLE reviews (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  booking_id BIGINT NOT NULL,
  hotel_id BIGINT NOT NULL,
  user_id BIGINT NOT NULL,
  rating TINYINT NOT NULL,
  tags JSON,
  content TEXT,
  images JSON,
  status TINYINT DEFAULT 1,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (booking_id) REFERENCES bookings(id),
  FOREIGN KEY (hotel_id) REFERENCES hotels(id),
  FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE exchange_rates (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  base_currency VARCHAR(8) NOT NULL,
  quote_currency VARCHAR(8) NOT NULL,
  rate DECIMAL(18,8) NOT NULL,
  as_of DATE NOT NULL,
  UNIQUE KEY uk_fx (base_currency, quote_currency, as_of)
);