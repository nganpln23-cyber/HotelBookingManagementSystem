DROP DATABASE IF EXISTS hotel_booking_db;
CREATE DATABASE IF NOT EXISTS hotel_booking_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE hotel_booking_db;

SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS bookings;
DROP TABLE IF EXISTS promotions;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS rooms;
DROP TABLE IF EXISTS room_types;
DROP TABLE IF EXISTS users;
SET FOREIGN_KEY_CHECKS = 1;

CREATE TABLE room_types (
    id INT AUTO_INCREMENT PRIMARY KEY,
    type_name VARCHAR(100) NOT NULL,
    description TEXT,
    price_per_night DECIMAL(12,2) NOT NULL DEFAULT 0,
    max_guests INT NOT NULL DEFAULT 1,
    image_url VARCHAR(500),
    image_data LONGBLOB,
    image_content_type VARCHAR(100)
);

CREATE TABLE rooms (
    id INT AUTO_INCREMENT PRIMARY KEY,
    room_number VARCHAR(20) NOT NULL UNIQUE,
    room_type_id INT NOT NULL,
    floor INT NOT NULL,
    status VARCHAR(30) NOT NULL DEFAULT 'AVAILABLE',
    description TEXT,
    CONSTRAINT fk_rooms_room_types
        FOREIGN KEY (room_type_id) REFERENCES room_types(id) ON DELETE CASCADE
);

CREATE TABLE customers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(150) NOT NULL,
    phone VARCHAR(30) NOT NULL,
    email VARCHAR(150),
    identity_number VARCHAR(50),
    address TEXT,
    password VARCHAR(64)
);

CREATE TABLE bookings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    room_id INT NOT NULL,
    check_in_date DATE NOT NULL,
    check_out_date DATE NOT NULL,
    status VARCHAR(30) NOT NULL DEFAULT 'PENDING',
    total_amount DECIMAL(12,2) NOT NULL DEFAULT 0,
    note TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    promo_code VARCHAR(30),
    discount_amount DECIMAL(12,2) NOT NULL DEFAULT 0,
    confirmation_code VARCHAR(20) NULL,
    checkin_code VARCHAR(20) NULL,
    is_online_paid TINYINT(1) NOT NULL DEFAULT 0,
    online_payment_ref VARCHAR(60) NULL,
    customer_email VARCHAR(150) NULL,
    CONSTRAINT fk_bookings_customers
        FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE CASCADE,
    CONSTRAINT fk_bookings_rooms
        FOREIGN KEY (room_id) REFERENCES rooms(id) ON DELETE CASCADE
);

CREATE TABLE promotions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    code VARCHAR(30) NOT NULL UNIQUE,
    description VARCHAR(255) NOT NULL,
    discount_percent DECIMAL(5,2) NOT NULL,
    min_completed_bookings INT NOT NULL DEFAULT 0,
    active TINYINT(1) NOT NULL DEFAULT 1
);

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(64) NOT NULL,
    full_name VARCHAR(150) NOT NULL,
    role VARCHAR(30) NOT NULL DEFAULT 'RECEPTIONIST'
);

CREATE TABLE payments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    booking_id INT NOT NULL,
    amount DECIMAL(12,2) NOT NULL,
    method VARCHAR(30) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'PAID',
    note VARCHAR(255),
    paid_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_payments_bookings
        FOREIGN KEY (booking_id) REFERENCES bookings(id) ON DELETE CASCADE
);

CREATE TABLE employees (
    id              INT AUTO_INCREMENT PRIMARY KEY,
    full_name       VARCHAR(100)    NOT NULL,
    phone           VARCHAR(20),
    email           VARCHAR(100),
    identity_number VARCHAR(20),
    address         TEXT,
    position        VARCHAR(50)     NOT NULL,
    department      VARCHAR(50)     NOT NULL,
    hire_date       DATE,
    salary          DECIMAL(12,0)   DEFAULT 0,
    status          ENUM('ACTIVE','INACTIVE','ON_LEAVE') DEFAULT 'ACTIVE',
    note            TEXT,
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO room_types(type_name, description, price_per_night, max_guests, image_url) VALUES
('Standard', 'Basic room for short stay', 500000, 2, 'https://images.unsplash.com/photo-1611892440504-42a792e24d32?w=800&q=80'),
('Deluxe', 'Comfortable room with better view', 850000, 3, 'https://images.unsplash.com/photo-1590490360182-c33d57733427?w=800&q=80'),
('Suite', 'Large room for family or VIP guest', 1500000, 4, 'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?w=800&q=80');

INSERT INTO rooms(room_number, room_type_id, floor, status, description) VALUES
('101', 1, 1, 'AVAILABLE', 'Standard room near lobby'),
('102', 1, 1, 'AVAILABLE', 'Standard room with city view'),
('201', 2, 2, 'BOOKED', 'Deluxe room with balcony'),
('202', 2, 2, 'AVAILABLE', 'Deluxe room with bathtub'),
('301', 3, 3, 'OCCUPIED', 'Suite room with living area'),
('302', 3, 3, 'MAINTENANCE', 'Suite room under maintenance');

INSERT INTO customers(full_name, phone, email, identity_number, address) VALUES
('Nguyen Van An', '0901000001', 'an@example.com', '079200000001', 'Ho Chi Minh City'),
('Tran Thi Binh', '0901000002', 'binh@example.com', '079200000002', 'Can Tho'),
('Le Minh Chau', '0901000003', 'chau@example.com', '079200000003', 'Vinh Long');

INSERT INTO bookings(customer_id, room_id, check_in_date, check_out_date, status, total_amount, note) VALUES
(1, 3, '2026-06-10', '2026-06-12', 'CONFIRMED', 1700000, 'Guest requested high floor'),
(2, 5, '2026-06-09', '2026-06-11', 'CHECKED_IN', 3000000, 'VIP guest'),
(3, 1, '2026-06-15', '2026-06-16', 'PENDING', 500000, 'Waiting for confirmation');

INSERT INTO users(username, password, full_name, role) VALUES
('admin',      SHA2('admin123',      256), 'Quản trị viên',      'ADMIN'),
('manager',    SHA2('manager123',    256), 'Quản lý báo cáo',    'MANAGER'),
('letan',      SHA2('letan123',      256), 'Nhân viên lễ tân',   'RECEPTIONIST'),
('phongstaff', SHA2('phongstaff123', 256), 'Nhân viên phòng',    'ROOM_STAFF');

INSERT INTO promotions(code, description, discount_percent, min_completed_bookings, active) VALUES
('WELCOME10', 'Giảm 10% cho lần đặt tiếp theo sau khi hoàn thành lưu trú đầu tiên', 10, 1, 1),
('LOYAL20', 'Giảm 20% cho khách hàng thân thiết đã hoàn thành từ 3 lượt lưu trú', 20, 3, 1);

INSERT INTO employees (full_name, phone, email, identity_number, address, position, department, hire_date, salary, status, note) VALUES
('Nguyễn Thị Lan',   '0901234567', 'lan.nguyen@grandbeach.vn',   '012345678901', 'Quận 1, TP.HCM',      'Trưởng lễ tân',          'Lễ tân',        '2020-01-15', 15000000, 'ACTIVE',   'Nhân viên xuất sắc năm 2023'),
('Trần Văn Nam',     '0912345678', 'nam.tran@grandbeach.vn',     '012345678902', 'Quận 3, TP.HCM',      'Lễ tân',                 'Lễ tân',        '2021-06-01',  9000000, 'ACTIVE',   NULL),
('Lê Thị Hoa',       '0923456789', 'hoa.le@grandbeach.vn',       '012345678903', 'Quận 5, TP.HCM',      'Nhân viên phục vụ',      'Nhà hàng',      '2021-03-15',  8000000, 'ACTIVE',   NULL),
('Phạm Minh Tuấn',   '0934567890', 'tuan.pham@grandbeach.vn',    '012345678904', 'Quận 7, TP.HCM',      'Đầu bếp',                'Bếp',           '2019-08-01', 12000000, 'ACTIVE',   'Chuyên ẩm thực Á'),
('Hoàng Văn Bình',   '0945678901', 'binh.hoang@grandbeach.vn',   '012345678905', 'Quận 10, TP.HCM',     'Bảo vệ',                 'Bảo vệ',        '2022-01-10',  7000000, 'ACTIVE',   NULL),
('Nguyễn Văn Hùng',  '0956789012', 'hung.nguyen@grandbeach.vn',  '012345678906', 'Bình Thạnh, TP.HCM',  'Kỹ thuật viên',          'Kỹ thuật',      '2020-11-20', 10000000, 'ACTIVE',   NULL),
('Trần Thị Mai',     '0967890123', 'mai.tran@grandbeach.vn',     '012345678907', 'Tân Bình, TP.HCM',    'Nhân viên dọn phòng',    'Buồng phòng',   '2022-05-01',  7500000, 'ON_LEAVE', 'Đang nghỉ thai sản'),
('Lê Văn Đức',       '0978901234', 'duc.le@grandbeach.vn',       '012345678908', 'Gò Vấp, TP.HCM',      'Quản lý ca',             'Ban quản lý',   '2018-03-01', 18000000, 'ACTIVE',   NULL),
('Vũ Thị Thu',       '0989012345', 'thu.vu@grandbeach.vn',       '012345678909', 'Phú Nhuận, TP.HCM',   'Nhân viên marketing',    'Marketing',     '2023-02-01',  9500000, 'ACTIVE',   NULL),
('Đinh Quang Khải',  '0990123456', 'khai.dinh@grandbeach.vn',    '012345678910', 'Quận 12, TP.HCM',     'Phụ bếp',                'Bếp',           '2023-07-15',  6500000, 'INACTIVE', 'Đã nghỉ việc 12/2024'),
('Bùi Thị Ngọc',     '0901122334', 'ngoc.bui@grandbeach.vn',     '012345678911', 'Thủ Đức, TP.HCM',     'Lễ tân',                 'Lễ tân',        '2023-09-01',  8500000, 'ACTIVE',   NULL),
('Phan Văn Cường',   '0912233445', 'cuong.phan@grandbeach.vn',   '012345678912', 'Long An',             'Trưởng nhóm buồng phòng','Buồng phòng',   '2021-04-01', 11000000, 'ACTIVE',   NULL);

-- ══════════════════════════════════════════════════════════════════════════════
-- DỮ LIỆU TEST CHO BÁO CÁO DOANH THU (EXPORT PDF / EXCEL)
-- Import file này là đủ: schema + seed + test data
-- ══════════════════════════════════════════════════════════════════════════════

-- Khách hàng bổ sung (IDs 4-15)
INSERT INTO customers(full_name, phone, email, identity_number, address) VALUES
('Pham Duc Long',   '0901100004', 'long@example.com',  '079200000004', 'Ha Noi'),
('Hoang Thi Thu',   '0901100005', 'thu@example.com',   '079200000005', 'Da Nang'),
('Vo Minh Khoa',    '0901100006', 'khoa@example.com',  '079200000006', 'Can Tho'),
('Nguyen Lan Anh',  '0901100007', 'lanh@example.com',  '079200000007', 'Ho Chi Minh'),
('Tran Van Duc',    '0901100008', 'duc@example.com',   '079200000008', 'Hue'),
('Le Phuong Thao',  '0901100009', 'thao@example.com',  '079200000009', 'Ho Chi Minh'),
('Bui Thanh Tung',  '0901100010', 'tung@example.com',  '079200000010', 'Nha Trang'),
('Dang Thi My',     '0901100011', 'my@example.com',    '079200000011', 'Da Lat'),
('Ngo Van Phuc',    '0901100012', 'phuc@example.com',  '079200000012', 'Ho Chi Minh'),
('Dinh Thi Lan',    '0901100013', 'dlan@example.com',  '079200000013', 'Hai Phong'),
('Mai Van Khanh',   '0901100014', 'khanh@example.com', '079200000014', 'Vung Tau'),
('Vuong Thi Hien',  '0901100015', 'hien@example.com',  '079200000015', 'Ho Chi Minh');

-- Bookings 2024 — 3 booking/tháng, đủ 4 quý
INSERT INTO bookings(customer_id, room_id, check_in_date, check_out_date, status, total_amount) VALUES
-- T1
(4,  1, '2024-01-05', '2024-01-07', 'CHECKED_OUT', 1000000),
(5,  3, '2024-01-15', '2024-01-17', 'CHECKED_OUT', 1700000),
(6,  5, '2024-01-22', '2024-01-25', 'CHECKED_OUT', 4500000),
-- T2
(7,  1, '2024-02-04', '2024-02-06', 'CHECKED_OUT', 1000000),
(8,  3, '2024-02-14', '2024-02-16', 'CHECKED_OUT', 1700000),
(9,  5, '2024-02-22', '2024-02-25', 'CHECKED_OUT', 4500000),
-- T3
(10, 1, '2024-03-06', '2024-03-08', 'CHECKED_OUT', 1000000),
(11, 3, '2024-03-16', '2024-03-18', 'CHECKED_OUT', 1700000),
(12, 5, '2024-03-23', '2024-03-26', 'CHECKED_OUT', 4500000),
-- T4
(13, 2, '2024-04-05', '2024-04-07', 'CHECKED_OUT', 1000000),
(14, 4, '2024-04-15', '2024-04-17', 'CHECKED_OUT', 1700000),
(15, 5, '2024-04-22', '2024-04-25', 'CHECKED_OUT', 4500000),
-- T5
(4,  1, '2024-05-07', '2024-05-09', 'CHECKED_OUT', 1000000),
(5,  3, '2024-05-17', '2024-05-19', 'CHECKED_OUT', 1700000),
(6,  5, '2024-05-24', '2024-05-27', 'CHECKED_OUT', 4500000),
-- T6
(7,  2, '2024-06-05', '2024-06-07', 'CHECKED_OUT', 1000000),
(8,  4, '2024-06-15', '2024-06-17', 'CHECKED_OUT', 1700000),
(9,  5, '2024-06-22', '2024-06-25', 'CHECKED_OUT', 4500000),
-- T7
(10, 1, '2024-07-06', '2024-07-08', 'CHECKED_OUT', 1000000),
(11, 3, '2024-07-18', '2024-07-20', 'CHECKED_OUT', 1700000),
(12, 5, '2024-07-25', '2024-07-28', 'CHECKED_OUT', 4500000),
-- T8
(13, 2, '2024-08-07', '2024-08-09', 'CHECKED_OUT', 1000000),
(14, 4, '2024-08-17', '2024-08-19', 'CHECKED_OUT', 1700000),
(15, 5, '2024-08-25', '2024-08-28', 'CHECKED_OUT', 4500000),
-- T9
(4,  1, '2024-09-06', '2024-09-08', 'CHECKED_OUT', 1000000),
(5,  3, '2024-09-18', '2024-09-20', 'CHECKED_OUT', 1700000),
(6,  5, '2024-09-25', '2024-09-28', 'CHECKED_OUT', 4500000),
-- T10
(7,  2, '2024-10-07', '2024-10-09', 'CHECKED_OUT', 1000000),
(8,  4, '2024-10-19', '2024-10-21', 'CHECKED_OUT', 1700000),
(9,  5, '2024-10-26', '2024-10-29', 'CHECKED_OUT', 4500000),
-- T11
(10, 1, '2024-11-06', '2024-11-08', 'CHECKED_OUT', 1000000),
(11, 3, '2024-11-16', '2024-11-18', 'CHECKED_OUT', 1700000),
(12, 5, '2024-11-23', '2024-11-26', 'CHECKED_OUT', 4500000),
-- T12
(13, 2, '2024-12-07', '2024-12-09', 'CHECKED_OUT', 1000000),
(14, 4, '2024-12-17', '2024-12-19', 'CHECKED_OUT', 1700000),
(15, 5, '2024-12-24', '2024-12-27', 'CHECKED_OUT', 4500000);

-- Bookings 2025 — 3 booking/tháng
INSERT INTO bookings(customer_id, room_id, check_in_date, check_out_date, status, total_amount) VALUES
-- T1
(4,  1, '2025-01-06', '2025-01-08', 'CHECKED_OUT', 1000000),
(5,  3, '2025-01-16', '2025-01-18', 'CHECKED_OUT', 1700000),
(6,  5, '2025-01-23', '2025-01-26', 'CHECKED_OUT', 4500000),
-- T2
(7,  2, '2025-02-05', '2025-02-07', 'CHECKED_OUT', 1000000),
(8,  4, '2025-02-15', '2025-02-17', 'CHECKED_OUT', 1700000),
(9,  5, '2025-02-22', '2025-02-25', 'CHECKED_OUT', 4500000),
-- T3
(10, 1, '2025-03-07', '2025-03-09', 'CHECKED_OUT', 1000000),
(11, 3, '2025-03-19', '2025-03-21', 'CHECKED_OUT', 1700000),
(12, 5, '2025-03-26', '2025-03-29', 'CHECKED_OUT', 4500000),
-- T4
(13, 2, '2025-04-05', '2025-04-07', 'CHECKED_OUT', 1000000),
(14, 4, '2025-04-15', '2025-04-17', 'CHECKED_OUT', 1700000),
(15, 5, '2025-04-23', '2025-04-26', 'CHECKED_OUT', 4500000),
-- T5
(4,  1, '2025-05-06', '2025-05-08', 'CHECKED_OUT', 1000000),
(5,  3, '2025-05-16', '2025-05-18', 'CHECKED_OUT', 1700000),
(6,  5, '2025-05-24', '2025-05-27', 'CHECKED_OUT', 4500000),
-- T6
(7,  2, '2025-06-06', '2025-06-08', 'CHECKED_OUT', 1000000),
(8,  4, '2025-06-16', '2025-06-18', 'CHECKED_OUT', 1700000),
(9,  5, '2025-06-23', '2025-06-26', 'CHECKED_OUT', 4500000),
-- T7
(10, 1, '2025-07-05', '2025-07-07', 'CHECKED_OUT', 1000000),
(11, 3, '2025-07-17', '2025-07-19', 'CHECKED_OUT', 1700000),
(12, 5, '2025-07-25', '2025-07-28', 'CHECKED_OUT', 4500000),
-- T8
(13, 2, '2025-08-07', '2025-08-09', 'CHECKED_OUT', 1000000),
(14, 4, '2025-08-17', '2025-08-19', 'CHECKED_OUT', 1700000),
(15, 5, '2025-08-25', '2025-08-28', 'CHECKED_OUT', 4500000),
-- T9
(4,  1, '2025-09-06', '2025-09-08', 'CHECKED_OUT', 1000000),
(5,  3, '2025-09-18', '2025-09-20', 'CHECKED_OUT', 1700000),
(6,  5, '2025-09-25', '2025-09-28', 'CHECKED_OUT', 4500000),
-- T10
(7,  2, '2025-10-07', '2025-10-09', 'CHECKED_OUT', 1000000),
(8,  4, '2025-10-17', '2025-10-19', 'CHECKED_OUT', 1700000),
(9,  5, '2025-10-25', '2025-10-28', 'CHECKED_OUT', 4500000),
-- T11
(10, 1, '2025-11-06', '2025-11-08', 'CHECKED_OUT', 1000000),
(11, 3, '2025-11-16', '2025-11-18', 'CHECKED_OUT', 1700000),
(12, 5, '2025-11-23', '2025-11-26', 'CHECKED_OUT', 4500000),
-- T12
(13, 2, '2025-12-06', '2025-12-08', 'CHECKED_OUT', 1000000),
(14, 4, '2025-12-18', '2025-12-20', 'CHECKED_OUT', 1700000),
(15, 5, '2025-12-25', '2025-12-28', 'CHECKED_OUT', 4500000);

-- Bookings 2026 T1-T5 (3/tháng) + T6 nhiều ngày để test daily
INSERT INTO bookings(customer_id, room_id, check_in_date, check_out_date, status, total_amount) VALUES
-- T1
(4,  1, '2026-01-05', '2026-01-07', 'CHECKED_OUT', 1000000),
(5,  3, '2026-01-15', '2026-01-17', 'CHECKED_OUT', 1700000),
(6,  5, '2026-01-22', '2026-01-25', 'CHECKED_OUT', 4500000),
-- T2
(7,  2, '2026-02-05', '2026-02-07', 'CHECKED_OUT', 1000000),
(8,  4, '2026-02-15', '2026-02-17', 'CHECKED_OUT', 1700000),
(9,  5, '2026-02-22', '2026-02-25', 'CHECKED_OUT', 4500000),
-- T3
(10, 1, '2026-03-07', '2026-03-09', 'CHECKED_OUT', 1000000),
(11, 3, '2026-03-17', '2026-03-19', 'CHECKED_OUT', 1700000),
(12, 5, '2026-03-25', '2026-03-28', 'CHECKED_OUT', 4500000),
-- T4
(13, 2, '2026-04-06', '2026-04-08', 'CHECKED_OUT', 1000000),
(14, 4, '2026-04-16', '2026-04-18', 'CHECKED_OUT', 1700000),
(15, 5, '2026-04-23', '2026-04-26', 'CHECKED_OUT', 4500000),
-- T5
(4,  1, '2026-05-07', '2026-05-09', 'CHECKED_OUT', 1000000),
(5,  3, '2026-05-17', '2026-05-19', 'CHECKED_OUT', 1700000),
(6,  5, '2026-05-25', '2026-05-28', 'CHECKED_OUT', 4500000),
-- T6 — nhiều ngày khác nhau để test báo cáo theo ngày
(7,  1, '2026-06-02', '2026-06-04', 'CHECKED_OUT', 1000000),
(8,  3, '2026-06-04', '2026-06-06', 'CHECKED_OUT', 1700000),
(9,  5, '2026-06-06', '2026-06-09', 'CHECKED_OUT', 4500000),
(10, 2, '2026-06-09', '2026-06-11', 'CHECKED_OUT', 1000000),
(11, 4, '2026-06-11', '2026-06-13', 'CHECKED_OUT', 1700000),
(12, 5, '2026-06-13', '2026-06-16', 'CHECKED_OUT', 4500000),
(13, 1, '2026-06-16', '2026-06-18', 'CHECKED_OUT', 1000000),
(14, 3, '2026-06-18', '2026-06-20', 'CHECKED_OUT', 1700000),
(15, 5, '2026-06-20', '2026-06-23', 'CHECKED_OUT', 4500000),
(4,  2, '2026-06-23', '2026-06-25', 'CHECKED_OUT', 1000000),
(5,  4, '2026-06-25', '2026-06-27', 'CHECKED_OUT', 1700000),
(6,  5, '2026-06-27', '2026-06-30', 'CHECKED_OUT', 4500000);

-- Payments: tự động tạo cho tất cả booking CHECKED_OUT
INSERT INTO payments(booking_id, amount, method, status, paid_at)
SELECT
    id,
    total_amount,
    ELT(1 + (id MOD 3), 'CASH', 'CARD', 'TRANSFER'),
    'PAID',
    TIMESTAMP(check_out_date) + INTERVAL 10 HOUR
FROM bookings
WHERE status = 'CHECKED_OUT';
