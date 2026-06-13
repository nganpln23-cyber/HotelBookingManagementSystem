<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Đăng ký tài khoản" />
<%@ include file="../layout/public-header.jsp" %>

<div class="container my-5">
    <div class="row justify-content-center">
        <div class="col-md-8 col-lg-6">
            <div class="card auth-card">
                <div class="card-body">
                    <div class="auth-icon"><i class="fas fa-user-plus"></i></div>
                    <h4 class="text-center font-weight-bold mb-1">Đăng ký tài khoản</h4>
                    <p class="text-center text-muted mb-4">Tạo tài khoản để theo dõi đặt phòng, hóa đơn và nhận ưu đãi cho lần đặt sau</p>

                    <c:if test="${not empty error}">
                        <div class="alert alert-danger">${error}</div>
                    </c:if>

                    <form method="post" action="${pageContext.request.contextPath}/account/register" id="registerForm">
                        <div class="form-row">
                            <div class="form-group col-md-6">
                                <label>Họ tên</label>
                                <input class="form-control" name="fullName" value="${customer.fullName}" required>
                            </div>
                            <div class="form-group col-md-6">
                                <label>Số điện thoại</label>
                                <input class="form-control" name="phone" value="${customer.phone}" required>
                            </div>
                        </div>
                        <div class="form-group">
                            <label>Email</label>
                            <input type="email" class="form-control" name="email" value="${customer.email}" required>
                        </div>
                        <div class="form-row">
                            <div class="form-group col-md-6">
                                <label>CCCD/Passport</label>
                                <input class="form-control" name="identityNumber" value="${customer.identityNumber}">
                            </div>
                            <div class="form-group col-md-6">
                                <label>Địa chỉ</label>
                                <input class="form-control" name="address" value="${customer.address}">
                            </div>
                        </div>
                        <div class="form-row">
                            <div class="form-group col-md-6">
                                <label>Mật khẩu</label>
                                <input type="password" class="form-control" name="password" id="password" required>
                            </div>
                            <div class="form-group col-md-6">
                                <label>Xác nhận mật khẩu</label>
                                <input type="password" class="form-control" id="confirmPassword" required>
                            </div>
                        </div>
                        <button type="submit" class="btn btn-primary btn-block"><i class="fas fa-user-plus mr-1"></i>Đăng ký</button>
                    </form>

                    <p class="text-center text-muted mt-4 mb-0">
                        Đã có tài khoản? <a href="${pageContext.request.contextPath}/account/login">Đăng nhập</a>
                    </p>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    document.getElementById("registerForm").addEventListener("submit", function (e) {
        var password = document.getElementById("password").value;
        var confirmPassword = document.getElementById("confirmPassword").value;
        if (password !== confirmPassword) {
            e.preventDefault();
            alert("Mật khẩu xác nhận không khớp.");
        }
    });
</script>

<%@ include file="../layout/public-footer.jsp" %>
