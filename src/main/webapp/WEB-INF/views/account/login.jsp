<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Đăng nhập" />
<c:set var="solidNav" value="true" />
<%@ include file="../layout/public-header.jsp" %>

<div class="ph-auth-bg">
    <div class="ph-auth-card">
        <div class="ph-auth-logo">
            <i class="fas fa-umbrella-beach mr-1"></i>Grand<span>.</span>Beach
        </div>
        <p class="ph-auth-subtitle">Đăng nhập để theo dõi đặt phòng và nhận ưu đãi</p>

        <c:if test="${param.error == '1'}">
            <div class="ph-alert ph-alert-danger"><i class="fas fa-exclamation-circle mr-2"></i>Email hoặc mật khẩu không đúng.</div>
        </c:if>
        <c:if test="${param.registered == '1'}">
            <div class="ph-alert ph-alert-success"><i class="fas fa-check-circle mr-2"></i>Đăng ký thành công! Mời bạn đăng nhập.</div>
        </c:if>

        <form method="post" action="${pageContext.request.contextPath}/account/login">
            <div style="margin-bottom:1rem;">
                <label>Email</label>
                <input type="email" class="ph-input" name="email" placeholder="email@example.com" required autofocus>
            </div>
            <div style="margin-bottom:1.5rem;">
                <label>Mật khẩu</label>
                <input type="password" class="ph-input" name="password" placeholder="••••••••" required>
            </div>
            <button type="submit" class="btn-auth-submit">
                <i class="fas fa-sign-in-alt mr-2"></i>Đăng nhập
            </button>
        </form>

        <hr class="ph-auth-divider">

        <p class="ph-auth-footer">
            Chưa có tài khoản? <a href="${pageContext.request.contextPath}/account/register">Đăng ký ngay</a>
        </p>
        <p class="ph-auth-footer" style="margin-top:.5rem;">
            <a href="${pageContext.request.contextPath}/" style="color:var(--ph-muted);">
                <i class="fas fa-arrow-left mr-1"></i>Về trang chủ
            </a>
        </p>
    </div>
</div>

<%@ include file="../layout/public-footer.jsp" %>
