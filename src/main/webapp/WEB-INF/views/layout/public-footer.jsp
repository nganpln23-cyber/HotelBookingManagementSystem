<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<footer class="ph-footer">
    <div class="container">
        <div class="row">
            <div class="col-lg-4 mb-5 mb-lg-0">
                <div class="ph-footer-brand"><i class="fas fa-umbrella-beach mr-2"></i>Grand<span>.</span>Beach</div>
                <p class="ph-footer-desc">
                    Khu nghỉ dưỡng 5 sao bên bờ biển — nơi tiếng sóng, cát trắng và hoàng hôn
                    tạo nên những kỳ nghỉ khó quên cho bạn và gia đình.
                </p>
            </div>
            <div class="col-6 col-md-3 col-lg-2 mb-4 mb-lg-0">
                <h6>Khám phá</h6>
                <ul class="ph-footer-links">
                    <li><a href="${pageContext.request.contextPath}/">Trang chủ</a></li>
                    <li><a href="${pageContext.request.contextPath}/rooms">Phòng trống</a></li>
                    <li><a href="${pageContext.request.contextPath}/booking/new">Đặt phòng</a></li>
                    <li><a href="${pageContext.request.contextPath}/account">Tài khoản</a></li>
                </ul>
            </div>
            <div class="col-6 col-md-3 col-lg-2 mb-4 mb-lg-0">
                <h6>Dịch vụ</h6>
                <ul class="ph-footer-links">
                    <li><a href="#">Nhà hàng</a></li>
                    <li><a href="#">Hồ bơi &amp; Spa</a></li>
                    <li><a href="#">Phòng hội nghị</a></li>
                    <li><a href="#">Đưa đón sân bay</a></li>
                </ul>
            </div>
            <div class="col-md-6 col-lg-4 mb-4 mb-lg-0">
                <h6>Liên hệ</h6>
                <ul class="ph-footer-links ph-footer-contact">
                    <li><i class="fas fa-map-marker-alt"></i>123 Nguyễn Huệ, Quận 1, TP. Hồ Chí Minh</li>
                    <li><i class="fas fa-phone"></i>+84 28 1123 4567</li>
                    <li><i class="fas fa-envelope"></i>reservation@grandhotel.vn</li>
                    <li><i class="fas fa-clock"></i>Lễ tân 24/7 &mdash; Phục vụ không nghỉ</li>
                </ul>
            </div>
        </div>
        <div class="ph-footer-divider">
            <span>&copy; 2026 Grand Beach Hotel. Bảo lưu mọi quyền.</span>
            <a href="${pageContext.request.contextPath}/login"
               style="color:rgba(255,255,255,.25);font-size:.75rem;text-decoration:none;transition:color .2s;"
               onmouseover="this.style.color='rgba(201,168,76,.7)'" onmouseout="this.style.color='rgba(255,255,255,.25)'">
                <i class="fas fa-shield-alt mr-1"></i>Quản trị
            </a>
        </div>
    </div>
</footer>
</body>
</html>
