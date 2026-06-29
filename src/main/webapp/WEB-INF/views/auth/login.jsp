<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Đăng nhập Quản trị — Grand Beach Hotel</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,600;0,700;1,400&family=Inter:wght@300;400;500;600;700&display=swap">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@fortawesome/fontawesome-free@5.15.4/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/public.css">
    <style>
        /* Admin login — phân biệt bằng viền vàng trên đầu card */
        .ph-admin-badge {
            display: inline-flex;
            align-items: center;
            gap: .4rem;
            background: rgba(201,168,76,.12);
            border: 1px solid rgba(201,168,76,.35);
            color: var(--ph-gold);
            font-size: .68rem;
            font-weight: 700;
            letter-spacing: .12em;
            text-transform: uppercase;
            padding: .3rem .8rem;
            border-radius: 20px;
            margin-bottom: 1.25rem;
        }
        .ph-auth-card.admin-card {
            border-top: 3px solid var(--ph-gold);
        }
        .ph-auth-card.admin-card .btn-auth-submit {
            background: var(--ph-gold);
            color: var(--ph-dark);
        }
        .ph-auth-card.admin-card .btn-auth-submit:hover {
            background: var(--ph-dark);
            color: white;
        }
        .admin-hint {
            background: rgba(201,168,76,.07);
            border: 1px dashed rgba(201,168,76,.3);
            border-radius: 6px;
            padding: .75rem 1rem;
            font-size: .8rem;
            color: var(--ph-muted);
            margin-top: 1rem;
            line-height: 1.6;
        }
        .admin-hint strong { color: var(--ph-dark); }
    </style>
</head>
<body>

<div class="ph-auth-bg" style="background-image: linear-gradient(135deg, rgba(13,27,42,.92) 0%, rgba(10,25,45,.85) 100%), url('https://images.unsplash.com/photo-1540541338537-1220059ec600?w=1400&q=75');">
    <div class="ph-auth-card admin-card">

        <%-- Logo --%>
        <div class="ph-auth-logo">
            <i class="fas fa-umbrella-beach mr-1"></i>Grand<span>.</span>Beach
        </div>
        <div class="text-center">
            <span class="ph-admin-badge">
                <i class="fas fa-shield-alt"></i> Cổng quản trị
            </span>
        </div>
        <p class="ph-auth-subtitle" style="margin-top:-.5rem;">Đăng nhập vào trang quản lý khách sạn</p>

        <%-- Error --%>
        <c:if test="${param.error == '1'}">
            <div class="ph-alert ph-alert-danger">
                <i class="fas fa-exclamation-triangle mr-2"></i>Sai tên đăng nhập hoặc mật khẩu.
            </div>
        </c:if>

        <%-- Form --%>
        <form action="${pageContext.request.contextPath}/login" method="post">
            <div style="margin-bottom:1rem;">
                <label>Tên đăng nhập</label>
                <div style="position:relative;">
                    <input type="text" class="ph-input" name="username"
                           placeholder="Nhập tên đăng nhập" required autofocus
                           style="padding-left:2.75rem;">
                    <i class="fas fa-user" style="position:absolute;left:.9rem;top:50%;transform:translateY(-50%);color:var(--ph-muted);font-size:.85rem;pointer-events:none;"></i>
                </div>
            </div>
            <div style="margin-bottom:1.5rem;">
                <label>Mật khẩu</label>
                <div style="position:relative;">
                    <input type="password" class="ph-input" name="password"
                           placeholder="••••••••" required
                           style="padding-left:2.75rem;">
                    <i class="fas fa-lock" style="position:absolute;left:.9rem;top:50%;transform:translateY(-50%);color:var(--ph-muted);font-size:.85rem;pointer-events:none;"></i>
                </div>
            </div>
            <button type="submit" class="btn-auth-submit">
                <i class="fas fa-sign-in-alt mr-2"></i>Đăng nhập quản trị
            </button>
        </form>

        <%-- Demo hint --%>
        <div class="admin-hint">
            <i class="fas fa-info-circle mr-1" style="color:var(--ph-gold);"></i>
            Tài khoản demo:
            <strong>admin / admin123</strong> hoặc <strong>letan / letan123</strong>
        </div>

        <hr class="ph-auth-divider">
        <p class="ph-auth-footer">
            <a href="${pageContext.request.contextPath}/" style="color:var(--ph-muted);">
                <i class="fas fa-arrow-left mr-1"></i>Về trang khách
            </a>
            <span style="margin:0 .75rem;color:var(--ph-border);">|</span>
            <a href="${pageContext.request.contextPath}/account/login" style="color:var(--ph-muted);">
                <i class="fas fa-user mr-1"></i>Đăng nhập khách
            </a>
        </p>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/jquery@3.6.4/dist/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
