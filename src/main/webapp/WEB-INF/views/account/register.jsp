<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Đăng ký tài khoản" />
<c:set var="solidNav" value="true" />
<%@ include file="../layout/public-header.jsp" %>

<div class="ph-auth-bg" style="align-items:flex-start;padding-top:5rem;padding-bottom:3rem;">
    <div class="ph-auth-card" style="max-width:560px;">
        <div class="ph-auth-logo">
            <i class="fas fa-umbrella-beach mr-1"></i>Grand<span>.</span>Beach
        </div>
        <p class="ph-auth-subtitle">Tạo tài khoản để quản lý đặt phòng và nhận ưu đãi</p>

        <c:if test="${not empty error}">
            <div class="ph-alert ph-alert-danger"><i class="fas fa-exclamation-circle mr-2"></i>${error}</div>
        </c:if>

        <form method="post" action="${pageContext.request.contextPath}/account/register" id="registerForm">
            <div class="row">
                <div class="col-md-6" style="margin-bottom:1rem;">
                    <label>Họ và tên <span style="color:#dc2626;">*</span></label>
                    <input class="ph-input" name="fullName" value="${customer.fullName}" placeholder="Nguyễn Văn A" required>
                </div>
                <div class="col-md-6" style="margin-bottom:1rem;">
                    <label>Số điện thoại <span style="color:#dc2626;">*</span></label>
                    <input class="ph-input" name="phone" value="${customer.phone}" placeholder="0912 345 678" required>
                </div>
            </div>
            <div style="margin-bottom:1rem;">
                <label>Email <span style="color:#dc2626;">*</span></label>
                <input type="email" class="ph-input" name="email" value="${customer.email}" placeholder="email@example.com" required>
            </div>
            <div class="row">
                <div class="col-md-6" style="margin-bottom:1rem;">
                    <label>CCCD / Passport</label>
                    <input class="ph-input" name="identityNumber" value="${customer.identityNumber}" placeholder="012345678901">
                </div>
                <div class="col-md-6" style="margin-bottom:1rem;">
                    <label>Địa chỉ</label>
                    <input class="ph-input" name="address" value="${customer.address}" placeholder="Quận, Tỉnh/Thành">
                </div>
            </div>
            <div class="row">
                <div class="col-md-6" style="margin-bottom:1.5rem;">
                    <label>Mật khẩu <span style="color:#dc2626;">*</span></label>
                    <input type="password" class="ph-input" name="password" id="password" placeholder="Tối thiểu 6 ký tự" required>
                </div>
                <div class="col-md-6" style="margin-bottom:1.5rem;">
                    <label>Xác nhận mật khẩu <span style="color:#dc2626;">*</span></label>
                    <input type="password" class="ph-input" id="confirmPassword" placeholder="Nhập lại mật khẩu" required>
                </div>
            </div>
            <button type="submit" class="btn-auth-submit">
                <i class="fas fa-user-plus mr-2"></i>Tạo tài khoản
            </button>
        </form>

        <hr class="ph-auth-divider">
        <p class="ph-auth-footer">
            Đã có tài khoản? <a href="${pageContext.request.contextPath}/account/login">Đăng nhập ngay</a>
        </p>
        <p class="ph-auth-footer" style="margin-top:.5rem;">
            <a href="${pageContext.request.contextPath}/" style="color:var(--ph-muted);">
                <i class="fas fa-arrow-left mr-1"></i>Về trang chủ
            </a>
        </p>
    </div>
</div>

<script>
document.getElementById("registerForm").addEventListener("submit", function(e){
    if(document.getElementById("password").value !== document.getElementById("confirmPassword").value){
        e.preventDefault();
        alert("Mật khẩu xác nhận không khớp.");
    }
});
</script>

<%@ include file="../layout/public-footer.jsp" %>
