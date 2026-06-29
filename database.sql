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
