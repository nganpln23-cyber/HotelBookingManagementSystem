# Hotel Booking Management System - Spring MVC + MySQL + JSP

Project đồ án Java Web dùng:

- NetBeans
- Maven
- Spring MVC
- MySQL
- JSP/JSTL
- Tomcat 10
- Cấu hình kiểu thầy dạy: `web.xml` + `dispatcher-servlet.xml`

## 1. Import database

Mở MySQL và chạy file:

```sql
database.sql
```

Database mặc định:

```text
hotel_booking_db
```

## 2. Sửa kết nối database

Mở file:

```text
src/main/webapp/WEB-INF/dispatcher-servlet.xml
```

Sửa đoạn này theo MySQL máy bạn:

```xml
<property name="username" value="root" />
<property name="password" value="" />
```

## 3. Chạy project trong NetBeans

1. File > Open Project
2. Chọn thư mục `HotelBookingManagementSystem_SpringMVC_WebXML`
3. Clean and Build
4. Run hoặc Deploy lên Tomcat 10

## 4. Link chạy

Trang người dùng:

```text
http://localhost:8080/HotelBookingManagementSystem/
```

Trang admin:

```text
http://localhost:8080/HotelBookingManagementSystem/admin/dashboard
```

## 5. Cấu trúc cấu hình Spring MVC

```text
src/main/webapp/WEB-INF/web.xml
src/main/webapp/WEB-INF/dispatcher-servlet.xml
```

Trong đó:

- `web.xml`: khai báo `DispatcherServlet`
- `dispatcher-servlet.xml`: khai báo component scan, view resolver, static resources, DataSource, JdbcTemplate

## 6. Chức năng đã có

- Trang chủ
- Danh sách phòng trống
- Đặt phòng ngoài website
- Dashboard admin
- CRUD loại phòng
- CRUD phòng
- CRUD khách hàng
- CRUD booking
- Confirm booking
- Check-in
- Check-out
- Tự tính tổng tiền booking
