<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>${pageTitle} — Grand Beach Hotel Admin</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/admin-lte@3.2/dist/css/adminlte.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@fortawesome/fontawesome-free@5.15.4/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/custom.css">
    <script src="https://cdn.jsdelivr.net/npm/jquery@3.6.4/dist/jquery.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
    <script src="https://cdn.jsdelivr.net/npm/flatpickr/dist/l10n/vn.js"></script>
</head>
<c:set var="uri" value="${pageContext.request.requestURI}" />
<body class="hold-transition sidebar-mini layout-fixed">
<div class="wrapper">

<nav class="main-header navbar navbar-expand navbar-white navbar-light">
    <ul class="navbar-nav">
        <li class="nav-item">
            <a class="nav-link" data-widget="pushmenu" href="#"><i class="fas fa-bars"></i></a>
        </li>
        <li class="nav-item d-none d-sm-inline-block">
            <a href="${pageContext.request.contextPath}/" class="nav-link">
                <i class="fas fa-umbrella-beach mr-1"></i>Grand Beach
            </a>
        </li>
    </ul>
    <ul class="navbar-nav ml-auto">
        <li class="nav-item dropdown">
            <a class="nav-link d-flex align-items-center gap-2" data-toggle="dropdown" href="#">
                <span class="avatar-circle">
                    <c:set var="fn" value="${sessionScope.currentUser.fullName}" />
                    <c:out value="${empty fn ? 'A' : fn.substring(0,1)}" />
                </span>
                <span class="d-none d-sm-inline"><c:out value="${sessionScope.currentUser.fullName}" default="Admin" /></span>
                <i class="fas fa-chevron-down ml-1" style="font-size:.6rem;opacity:.5;"></i>
            </a>
            <div class="dropdown-menu dropdown-menu-right" style="min-width:210px;">
                <div class="dropdown-item-text px-3 py-2">
                    <div style="font-weight:700;font-size:.85rem;"><c:out value="${sessionScope.currentUser.fullName}" /></div>
                    <div style="font-size:.72rem;color:#64748b;text-transform:uppercase;letter-spacing:.06em;"><c:out value="${sessionScope.currentUser.role}" /></div>
                </div>
                <div class="dropdown-divider"></div>
                <a href="${pageContext.request.contextPath}/logout" class="dropdown-item text-danger">
                    <i class="fas fa-sign-out-alt mr-2"></i>Đăng xuất
                </a>
            </div>
        </li>
    </ul>
</nav>

<aside class="main-sidebar sidebar-light-primary elevation-0">
    <a href="${pageContext.request.contextPath}/admin/dashboard" class="brand-link">
        <div class="brand-icon"><i class="fas fa-umbrella-beach"></i></div>
        <span class="brand-text">Grand Beach</span>
    </a>
    <div class="sidebar">
        <nav class="mt-2 pb-4">
            <c:set var="role" value="${sessionScope.currentUser.role}" />
            <ul class="nav nav-pills nav-sidebar flex-column" data-widget="treeview" role="menu">

                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/admin/dashboard"
                       class="nav-link ${uri.contains('/admin/dashboard') ? 'active' : ''}">
                        <i class="nav-icon fas fa-th-large"></i><p>Dashboard</p>
                    </a>
                </li>

                <%-- QUẢN LÝ: ADMIN only --%>
                <c:if test="${role == 'ADMIN'}">
                <li class="nav-header">QUẢN LÝ</li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/admin/room-types"
                       class="nav-link ${uri.contains('/admin/room-types') ? 'active' : ''}">
                        <i class="nav-icon fas fa-layer-group"></i><p>Loại phòng</p>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/admin/customers"
                       class="nav-link ${uri.contains('/admin/customers') ? 'active' : ''}">
                        <i class="nav-icon fas fa-users"></i><p>Khách hàng</p>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/admin/employees"
                       class="nav-link ${uri.contains('/admin/employees') ? 'active' : ''}">
                        <i class="nav-icon fas fa-user-tie"></i><p>Nhân viên</p>
                    </a>
                </li>
                </c:if>

                <%-- PHÒNG: ADMIN + ROOM_STAFF --%>
                <c:if test="${role == 'ADMIN' || role == 'ROOM_STAFF'}">
                <c:if test="${role == 'ROOM_STAFF'}"><li class="nav-header">QUẢN LÝ PHÒNG</li></c:if>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/admin/rooms"
                       class="nav-link ${uri.contains('/admin/rooms') ? 'active' : ''}">
                        <i class="nav-icon fas fa-door-open"></i><p>Phòng</p>
                    </a>
                </li>
                </c:if>

                <%-- ĐẶT PHÒNG: ADMIN + RECEPTIONIST --%>
                <c:if test="${role == 'ADMIN' || role == 'RECEPTIONIST'}">
                <li class="nav-header">ĐẶT PHÒNG</li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/admin/bookings"
                       class="nav-link ${uri.contains('/admin/bookings') && !uri.contains('/calendar') ? 'active' : ''}">
                        <i class="nav-icon fas fa-calendar-check"></i><p>Danh sách</p>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/admin/bookings/calendar"
                       class="nav-link ${uri.contains('/admin/bookings/calendar') ? 'active' : ''}">
                        <i class="nav-icon fas fa-calendar-alt"></i><p>Lịch đặt phòng</p>
                    </a>
                </li>
                <c:if test="${role == 'ADMIN'}">
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/admin/customers"
                       class="nav-link" style="display:none;">
                    </a>
                </li>
                </c:if>
                </c:if>

                <%-- VẬN HÀNH: ADMIN + RECEPTIONIST --%>
                <c:if test="${role == 'ADMIN' || role == 'RECEPTIONIST'}">
                <li class="nav-header">VẬN HÀNH</li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/admin/checkinout"
                       class="nav-link ${uri.contains('/admin/checkinout') ? 'active' : ''}">
                        <i class="nav-icon fas fa-key"></i><p>Check-in / Check-out</p>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/admin/payments"
                       class="nav-link ${uri.contains('/admin/payments') ? 'active' : ''}">
                        <i class="nav-icon fas fa-money-bill-wave"></i><p>Thanh toán</p>
                    </a>
                </li>
                </c:if>

                <%-- RECEPTIONIST: xem customers --%>
                <c:if test="${role == 'RECEPTIONIST'}">
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/admin/customers"
                       class="nav-link ${uri.contains('/admin/customers') ? 'active' : ''}">
                        <i class="nav-icon fas fa-users"></i><p>Khách hàng</p>
                    </a>
                </li>
                </c:if>

                <%-- BÁO CÁO: ADMIN + MANAGER --%>
                <c:if test="${role == 'ADMIN' || role == 'MANAGER'}">
                <li class="nav-header">BÁO CÁO</li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/admin/reports/revenue"
                       class="nav-link ${uri.contains('/admin/reports/revenue') ? 'active' : ''}">
                        <i class="nav-icon fas fa-chart-bar"></i><p>Doanh thu</p>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/admin/reports/occupancy"
                       class="nav-link ${uri.contains('/admin/reports/occupancy') ? 'active' : ''}">
                        <i class="nav-icon fas fa-hotel"></i><p>Tỷ lệ lấp đầy</p>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/admin/reports/top-customers"
                       class="nav-link ${uri.contains('/admin/reports/top-customers') ? 'active' : ''}">
                        <i class="nav-icon fas fa-trophy"></i><p>Top khách hàng</p>
                    </a>
                </li>
                </c:if>

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
            <c:if test="${not empty error}">
                <div class="alert alert-danger alert-dismissible fade show">
                    <button type="button" class="close" data-dismiss="alert">&times;</button>
                    <i class="fas fa-exclamation-circle mr-1"></i>${error}
                </div>
            </c:if>
            <c:if test="${not empty success}">
                <div class="alert alert-success alert-dismissible fade show">
                    <button type="button" class="close" data-dismiss="alert">&times;</button>
                    <i class="fas fa-check-circle mr-1"></i>${success}
                </div>
            </c:if>
