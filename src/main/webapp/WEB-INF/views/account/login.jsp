<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Đăng nhập" />
<%@ include file="../layout/public-header.jsp" %>

<div class="container my-5">
    <div class="row justify-content-center">
        <div class="col-md-6 col-lg-5">
            <div class="card auth-card">
                <div class="card-body">
                    <div class="auth-icon"><i class="fas fa-user-circle"></i></div>
                    <h4 class="text-center font-weight-bold mb-1">Đăng nhập</h4>
                    <p class="text-center text-muted mb-4">Theo dõi đặt phòng, hóa đơn và ưu đãi của bạn</p>

                    <c:if test="${param.error == '1'}">
                        <div class="alert alert-danger">Email hoặc mật khẩu không đúng.</div>
                    </c:if>

                    <form method="post" action="${pageContext.request.contextPath}/account/login">
                        <div class="form-group">
                            <label>Email</label>
                            <input type="email" class="form-control" name="email" required autofocus>
                        </div>
                        <div class="form-group">
                            <label>Mật khẩu</label>
                            <input type="password" class="form-control" name="password" required>
                        </div>
                        <button type="submit" class="btn btn-primary btn-block"><i class="fas fa-sign-in-alt mr-1"></i>Đăng nhập</button>
                    </form>

                    <p class="text-center text-muted mt-4 mb-0">
                        Chưa có tài khoản? <a href="${pageContext.request.contextPath}/account/register">Đăng ký ngay</a>
                    </p>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="../layout/public-footer.jsp" %>
