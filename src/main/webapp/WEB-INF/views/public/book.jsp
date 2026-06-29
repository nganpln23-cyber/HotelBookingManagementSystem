<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Đặt phòng" />
<c:set var="solidNav" value="true" />
<%@ include file="../layout/public-header.jsp" %>

<%-- PAGE HERO --%>
<div class="ph-page-hero">
    <div class="container">
        <div class="ph-breadcrumb">
            <a href="${pageContext.request.contextPath}/">Trang chủ</a>
            <span>&rsaquo;</span>
            <a href="${pageContext.request.contextPath}/rooms">Phòng trống</a>
            <span>&rsaquo;</span> Đặt phòng
        </div>
        <h1>Đặt phòng của bạn</h1>
        <p>Điền thông tin bên dưới, chúng tôi sẽ xác nhận trong vòng 30 phút</p>
    </div>
</div>

<div style="background:var(--ph-bg); padding:3rem 0 4rem;">
    <div class="container">

        <c:if test="${not empty error}">
            <div class="ph-alert ph-alert-danger"><i class="fas fa-exclamation-circle mr-2"></i>${error}</div>
        </c:if>

        <%-- Login/account notice --%>
        <c:if test="${not empty currentCustomer}">
            <div class="ph-alert ph-alert-info d-flex justify-content-between align-items-center flex-wrap" style="gap:.5rem;">
                <span><i class="fas fa-user-circle mr-2"></i>Đặt phòng với tài khoản <strong>${currentCustomer.email}</strong> — lịch sử được lưu tự động.</span>
                <a href="${pageContext.request.contextPath}/account" style="color:var(--ph-gold);font-weight:600;font-size:.88rem;white-space:nowrap;">Xem ưu đãi &rarr;</a>
            </div>
        </c:if>
        <c:if test="${empty currentCustomer}">
            <div class="ph-alert ph-alert-info d-flex justify-content-between align-items-center flex-wrap" style="gap:.5rem;">
                <span><i class="fas fa-info-circle mr-2"></i>Đặt phòng không cần đăng nhập. <a href="${pageContext.request.contextPath}/account/login" style="color:var(--ph-gold);font-weight:600;">Đăng nhập</a> để dùng mã ưu đãi và xem lịch sử.</span>
            </div>
        </c:if>

        <div class="row">
            <%-- Room summary sidebar --%>
            <c:if test="${not empty selectedRoom}">
                <div class="col-lg-4 mb-4 order-lg-2">
                    <div class="ph-room-summary">
                        <img src="${selectedRoom.roomType.getImageDisplayUrl(pageContext.request.contextPath)}"
                             class="ph-room-summary-img" alt="${selectedRoom.roomType.typeName}">
                        <div class="ph-room-summary-body">
                            <div style="font-size:.7rem;font-weight:700;letter-spacing:.1em;text-transform:uppercase;color:var(--ph-gold);margin-bottom:.4rem;">${selectedRoom.roomType.typeName}</div>
                            <h5>Phòng ${selectedRoom.roomNumber}</h5>
                            <div style="font-size:.82rem;color:var(--ph-muted);margin-bottom:.75rem;">
                                <i class="fas fa-user-friends mr-1" style="color:var(--ph-gold);"></i>Tối đa ${selectedRoom.roomType.maxGuests} khách
                                <span class="mx-2">&middot;</span>
                                <i class="fas fa-layer-group mr-1" style="color:var(--ph-gold);"></i>Tầng ${selectedRoom.floor}
                            </div>
                            <p style="font-size:.85rem;color:var(--ph-muted);line-height:1.6;margin-bottom:1rem;">${selectedRoom.roomType.description}</p>
                            <hr style="border-color:var(--ph-border);">
                            <div class="d-flex justify-content-between align-items-center">
                                <span style="font-size:.82rem;color:var(--ph-muted);">Giá/đêm</span>
                                <span class="ph-price-big">
                                    <fmt:formatNumber value="${selectedRoom.roomType.pricePerNight}" type="number" groupingUsed="true"/> <small style="font-size:.8rem;font-weight:400;color:var(--ph-muted);font-family:Inter,sans-serif;">VND</small>
                                </span>
                            </div>
                            <div style="margin-top:.75rem;padding:.75rem;background:var(--ph-gold-soft);border-radius:6px;font-size:.8rem;color:var(--ph-text);">
                                <i class="fas fa-shield-alt mr-1" style="color:var(--ph-gold);"></i>
                                Giá tốt nhất đảm bảo &mdash; không phụ phí ẩn
                            </div>
                        </div>
                    </div>
                </div>
            </c:if>

            <%-- Booking form --%>
            <div class="${not empty selectedRoom ? 'col-lg-8 order-lg-1' : 'col-lg-12'}">
                <form method="post" action="${pageContext.request.contextPath}/booking/save">

                    <%-- Customer info --%>
                    <div class="ph-booking-card mb-4">
                        <div class="card-head">
                            <h5><i class="fas fa-user mr-2"></i>Thông tin khách hàng</h5>
                        </div>
                        <div class="card-body">
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label>Họ và tên <span style="color:#dc2626;">*</span></label>
                                    <input class="form-control" name="fullName" value="${bookingForm.fullName}" placeholder="Nguyễn Văn A" required>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label>Số điện thoại <span style="color:#dc2626;">*</span></label>
                                    <input class="form-control" name="phone" value="${bookingForm.phone}" placeholder="0912 345 678" required>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label>Email</label>
                                    <input class="form-control" type="email" name="email" value="${bookingForm.email}" placeholder="email@example.com">
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label>CCCD / Passport</label>
                                    <input class="form-control" name="identityNumber" value="${bookingForm.identityNumber}" placeholder="012345678901">
                                </div>
                                <div class="col-12 mb-0">
                                    <label>Địa chỉ</label>
                                    <input class="form-control" name="address" value="${bookingForm.address}" placeholder="Số nhà, đường, quận, tỉnh/thành">
                                </div>
                            </div>
                        </div>
                    </div>

                    <%-- Booking details --%>
                    <div class="ph-booking-card mb-4">
                        <div class="card-head">
                            <h5><i class="fas fa-calendar-alt mr-2"></i>Chi tiết đặt phòng</h5>
                        </div>
                        <div class="card-body">
                            <div class="row">
                                <div class="col-12 mb-3">
                                    <label>Chọn phòng <span style="color:#dc2626;">*</span></label>
                                    <select class="form-control" name="roomId" required>
                                        <c:forEach var="r" items="${rooms}">
                                            <option value="${r.id}" ${bookingForm.roomId == r.id ? 'selected' : ''}>
                                                Phòng ${r.roomNumber} — ${r.roomType.typeName}
                                                (<fmt:formatNumber value="${r.roomType.pricePerNight}" type="number" groupingUsed="true"/> VND/đêm)
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label>Ngày nhận phòng <span style="color:#dc2626;">*</span></label>
                                    <input class="form-control" type="text" id="bookCheckIn" name="checkInDate"
                                           value="${bookingForm.checkInDate}" placeholder="Chọn ngày" autocomplete="off" required>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label>Ngày trả phòng <span style="color:#dc2626;">*</span></label>
                                    <input class="form-control" type="text" id="bookCheckOut" name="checkOutDate"
                                           value="${bookingForm.checkOutDate}" placeholder="Chọn ngày" autocomplete="off" required>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label>Mã ưu đãi</label>
                                    <input class="form-control" name="promoCode" value="${bookingForm.promoCode}" placeholder="VD: WELCOME10">
                                    <c:if test="${empty currentCustomer}">
                                        <small style="font-size:.75rem;color:var(--ph-muted);margin-top:.3rem;display:block;">
                                            <a href="${pageContext.request.contextPath}/account/login" style="color:var(--ph-gold);font-weight:600;">Đăng nhập</a> để sử dụng mã ưu đãi cá nhân.
                                        </small>
                                    </c:if>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label>Ghi chú</label>
                                    <textarea class="form-control" name="note" rows="2" style="height:auto;"
                                              placeholder="Yêu cầu đặc biệt, giờ đến...">${bookingForm.note}</textarea>
                                </div>
                            </div>
                        </div>
                    </div>

                    <%-- Submit --%>
                    <div style="display:flex;align-items:center;gap:1rem;flex-wrap:wrap;">
                        <button type="submit" class="btn-book-submit">
                            <i class="fas fa-credit-card"></i> Tiếp tục thanh toán
                        </button>
                        <p style="font-size:.8rem;color:var(--ph-muted);margin:0;">
                            <i class="fas fa-lock mr-1" style="color:var(--ph-gold);"></i>
                            Bước tiếp theo: nhập thông tin thẻ thanh toán an toàn
                        </p>
                    </div>

                </form>
            </div>
        </div>
    </div>
</div>

<script>
(function(){
    var fd = [<c:forEach var="d" items="${fullyBookedDates}">"${d}",</c:forEach>];
    var co = flatpickr("#bookCheckOut",{locale:"vn",dateFormat:"Y-m-d",altInput:true,altFormat:"d/m/Y",minDate:new Date().fp_incr(1),disable:fd});
    flatpickr("#bookCheckIn",{locale:"vn",dateFormat:"Y-m-d",altInput:true,altFormat:"d/m/Y",minDate:"today",disable:fd,onChange:function(d){if(d[0])co.set("minDate",new Date(d[0].getTime()+86400000));}});
})();
</script>

<%@ include file="../layout/public-footer.jsp" %>
