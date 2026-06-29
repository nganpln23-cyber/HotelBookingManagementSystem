<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>${pageTitle} — Grand Beach Hotel</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,600;0,700;1,400&family=Inter:wght@300;400;500;600;700&display=swap">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@fortawesome/fontawesome-free@5.15.4/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/public.css">
    <script src="https://cdn.jsdelivr.net/npm/jquery@3.6.4/dist/jquery.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
    <script src="https://cdn.jsdelivr.net/npm/flatpickr/dist/l10n/vn.js"></script>
</head>
<body>

<nav class="ph-nav ${not empty solidNav ? 'ph-nav-solid' : ''}" id="phNav">
    <div class="container">
        <a class="ph-nav-brand" href="${pageContext.request.contextPath}/">
            <i class="fas fa-umbrella-beach"></i>Grand<span class="brand-dot">.</span>Beach
        </a>
        <button class="ph-nav-toggle" id="navToggle" aria-label="Menu">
            <span></span><span></span><span></span>
        </button>
        <ul class="ph-nav-links" id="navLinks">
            <li><a href="${pageContext.request.contextPath}/">Trang chủ</a></li>
            <li><a href="${pageContext.request.contextPath}/rooms">Phòng trống</a></li>
            <c:choose>
                <c:when test="${not empty sessionScope.currentCustomer}">
                    <li><a href="${pageContext.request.contextPath}/account"><i class="fas fa-user-circle mr-1"></i>${sessionScope.currentCustomer.fullName}</a></li>
                    <li><a href="${pageContext.request.contextPath}/account/logout">Đăng xuất</a></li>
                </c:when>
                <c:otherwise>
                    <li><a href="${pageContext.request.contextPath}/account/login">Đăng nhập</a></li>
                    <li><a href="${pageContext.request.contextPath}/account/register">Đăng ký</a></li>
                </c:otherwise>
            </c:choose>
            <li>
                <a href="${pageContext.request.contextPath}/login"
                   title="Quản trị viên"
                   style="opacity:.55;font-size:.8rem;padding:.4rem .6rem !important;transition:opacity .2s;"
                   onmouseover="this.style.opacity='1'" onmouseout="this.style.opacity='.55'">
                    <i class="fas fa-shield-alt"></i>
                </a>
            </li>
            <li><a href="${pageContext.request.contextPath}/booking/new" class="btn-nav-book ml-lg-2">Đặt phòng</a></li>
        </ul>
    </div>
</nav>

<script>
(function(){
    var nav = document.getElementById('phNav');
    var toggle = document.getElementById('navToggle');
    var links = document.getElementById('navLinks');
    if(nav && !nav.classList.contains('ph-nav-solid')){
        window.addEventListener('scroll', function(){
            nav.classList.toggle('scrolled', window.scrollY > 60);
        });
    }
    if(toggle && links){
        toggle.addEventListener('click', function(){ links.classList.toggle('open'); });
    }
})();
</script>
