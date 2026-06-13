<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>${pageTitle} - Hotel Booking Management</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/admin-lte@3.2/dist/css/adminlte.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@fortawesome/fontawesome-free@5.15.4/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/custom.css">
    <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
    <script src="https://cdn.jsdelivr.net/npm/flatpickr/dist/l10n/vn.js"></script>
</head>
<body class="hold-transition sidebar-mini layout-fixed">
<div class="wrapper">
    <nav class="main-header navbar navbar-expand navbar-white navbar-light">
        <ul class="navbar-nav">
            <li class="nav-item"><a class="nav-link" data-widget="pushmenu" href="#"><i class="fas fa-bars"></i></a></li>
            <li class="nav-item d-none d-sm-inline-block"><a href="${pageContext.request.contextPath}/" class="nav-link"><i class="fas fa-globe mr-1"></i>Website</a></li>
            <li class="nav-item d-none d-sm-inline-block"><a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-link"><i class="fas fa-th-large mr-1"></i>Admin</a></li>
        </ul>
        <ul class="navbar-nav ml-auto">
            <li class="nav-item dropdown">
                <a class="nav-link" data-toggle="dropdown" href="#">
                    <i class="fas fa-user-circle mr-1"></i>
                    <c:out value="${sessionScope.currentUser.fullName}" default="Người dùng" />
                </a>
                <div class="dropdown-menu dropdown-menu-right">
                    <div class="dropdown-item">
                        <div class="user-panel-name"><c:out value="${sessionScope.currentUser.fullName}" /></div>
                        <div class="user-panel-role"><c:out value="${sessionScope.currentUser.role}" /></div>
                    </div>
                    <div class="dropdown-divider"></div>
                    <a href="${pageContext.request.contextPath}/logout" class="dropdown-item text-danger">
                        <i class="fas fa-sign-out-alt mr-2"></i>Đăng xuất
                    </a>
                </div>
            </li>
        </ul>
    </nav>

    <aside class="main-sidebar sidebar-dark-primary elevation-4">
        <a href="${pageContext.request.contextPath}/admin/dashboard" class="brand-link">
            <i class="fas fa-hotel ml-2 text-white"></i>
            <span class="brand-text font-weight-light ml-2">Hotel Management</span>
        </a>
        <div class="sidebar">
            <nav class="mt-2">
                <ul class="nav nav-pills nav-sidebar flex-column" data-widget="treeview" role="menu">
                    <li class="nav-item"><a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-link"><i class="nav-icon fas fa-tachometer-alt"></i><p>Dashboard</p></a></li>

                    <li class="nav-header">QUẢN LÝ</li>
                    <li class="nav-item"><a href="${pageContext.request.contextPath}/admin/room-types" class="nav-link"><i class="nav-icon fas fa-bed"></i><p>Loại phòng</p></a></li>
                    <li class="nav-item"><a href="${pageContext.request.contextPath}/admin/rooms" class="nav-link"><i class="nav-icon fas fa-door-open"></i><p>Phòng</p></a></li>
                    <li class="nav-item"><a href="${pageContext.request.contextPath}/admin/customers" class="nav-link"><i class="nav-icon fas fa-users"></i><p>Khách hàng</p></a></li>
                    <li class="nav-item"><a href="${pageContext.request.contextPath}/admin/bookings" class="nav-link"><i class="nav-icon fas fa-calendar-check"></i><p>Đặt phòng</p></a></li>

                    <li class="nav-header">VẬN HÀNH</li>
                    <li class="nav-item"><a href="${pageContext.request.contextPath}/admin/checkinout" class="nav-link"><i class="nav-icon fas fa-key"></i><p>Check-in / Check-out</p></a></li>
                    <li class="nav-item"><a href="${pageContext.request.contextPath}/admin/payments" class="nav-link"><i class="nav-icon fas fa-money-bill-wave"></i><p>Thanh toán</p></a></li>

                    <li class="nav-header">BÁO CÁO</li>
                    <li class="nav-item"><a href="${pageContext.request.contextPath}/admin/reports/revenue" class="nav-link"><i class="nav-icon fas fa-chart-line"></i><p>Doanh thu</p></a></li>
                </ul>
            </nav>
        </div>
    </aside>

    <div class="content-wrapper">
        <section class="content-header">
            <div class="container-fluid">
                <h1>${pageTitle}</h1>
            </div>
        </section>
        <section class="content">
            <div class="container-fluid">
