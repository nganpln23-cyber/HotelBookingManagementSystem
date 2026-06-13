<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>${pageTitle} - Hotel Booking</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/admin-lte@3.2/dist/css/adminlte.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@fortawesome/fontawesome-free@5.15.4/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/custom.css">
    <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
    <script src="https://cdn.jsdelivr.net/npm/flatpickr/dist/l10n/vn.js"></script>
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-light bg-white border-bottom sticky-top shadow-sm">
    <div class="container">
        <a class="navbar-brand font-weight-bold" href="${pageContext.request.contextPath}/">
            <i class="fas fa-hotel mr-2" style="color: var(--brand);"></i>Hotel Booking
        </a>
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#publicNavbar">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="publicNavbar">
            <div class="navbar-nav ml-auto align-items-lg-center">
                <a class="nav-link" href="${pageContext.request.contextPath}/rooms">Phòng trống</a>
                <c:if test="${not empty sessionScope.currentCustomer}">
                    <a class="nav-link" href="${pageContext.request.contextPath}/account"><i class="fas fa-user-circle mr-1"></i>${sessionScope.currentCustomer.fullName}</a>
                    <a class="nav-link" href="${pageContext.request.contextPath}/account/logout">Đăng xuất</a>
                </c:if>
                <c:if test="${empty sessionScope.currentCustomer}">
                    <a class="nav-link" href="${pageContext.request.contextPath}/account/login">Đăng nhập</a>
                    <a class="nav-link" href="${pageContext.request.contextPath}/account/register">Đăng ký</a>
                </c:if>
                <a class="nav-link" href="${pageContext.request.contextPath}/admin/dashboard">Admin</a>
                <a class="btn btn-primary ml-lg-2" href="${pageContext.request.contextPath}/booking/new">Đặt phòng ngay</a>
            </div>
        </div>
    </div>
</nav>
