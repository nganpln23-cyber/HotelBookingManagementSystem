<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Đặt phòng" />
<%@ include file="../layout/public-header.jsp" %>

<section class="public-hero py-5">
    <div class="container text-center">
        <h1 class="h2 mb-2">Đặt phòng</h1>
        <p class="lead mb-0">Điền thông tin bên dưới, chúng tôi sẽ liên hệ xác nhận sớm nhất</p>
    </div>
</section>

<div class="container mt-5 mb-5">
    <c:if test="${not empty error}">
        <div class="alert alert-danger">${error}</div>
    </c:if>

    <c:if test="${not empty currentCustomer}">
        <div class="alert alert-info d-flex justify-content-between align-items-center flex-wrap">
            <span><i class="fas fa-user-circle mr-1"></i>Bạn đang đặt phòng với tài khoản <strong>${currentCustomer.email}</strong>. Đặt phòng này sẽ được lưu vào lịch sử tài khoản của bạn.</span>
            <a href="${pageContext.request.contextPath}/account" class="font-weight-bold">Xem ưu đãi của tôi &rarr;</a>
        </div>
    </c:if>
    <c:if test="${empty currentCustomer}">
        <div class="alert alert-light border d-flex justify-content-between align-items-center flex-wrap">
            <span><i class="fas fa-info-circle mr-1"></i>Bạn có thể đặt phòng không cần đăng nhập. Đăng nhập để theo dõi lịch sử đặt phòng, hóa đơn và nhận mã ưu đãi cho lần sau.</span>
            <span>
                <a href="${pageContext.request.contextPath}/account/login" class="font-weight-bold mr-3">Đăng nhập</a>
                <a href="${pageContext.request.contextPath}/account/register" class="font-weight-bold">Đăng ký</a>
            </span>
        </div>
    </c:if>

    <div class="row">
        <c:if test="${not empty selectedRoom}">
            <div class="col-lg-4 mb-4">
                <div class="card room-card">
                    <img src="${selectedRoom.roomType.getImageDisplayUrl(pageContext.request.contextPath)}" class="room-img" alt="${selectedRoom.roomType.typeName}">
                    <div class="card-body">
                        <h5 class="font-weight-bold">Phòng ${selectedRoom.roomNumber}</h5>
                        <p class="text-muted mb-2">${selectedRoom.roomType.typeName} &middot; tối đa ${selectedRoom.roomType.maxGuests} khách</p>
                        <p class="price mb-3"><fmt:formatNumber value="${selectedRoom.roomType.pricePerNight}" type="number" groupingUsed="true" /> VND/đêm</p>
                        <p class="text-muted mb-0">${selectedRoom.roomType.description}</p>
                    </div>
                </div>
            </div>
        </c:if>
        <div class="${not empty selectedRoom ? 'col-lg-8' : 'col-lg-12'}">
            <div class="card">
                <form method="post" action="${pageContext.request.contextPath}/booking/save">
                    <div class="card-body">
                        <div class="form-row">
                            <div class="form-group col-md-6">
                                <label>Họ tên</label>
                                <input class="form-control" name="fullName" value="${bookingForm.fullName}" required>
                            </div>
                            <div class="form-group col-md-6">
                                <label>Số điện thoại</label>
                                <input class="form-control" name="phone" value="${bookingForm.phone}" required>
                            </div>
                        </div>
                        <div class="form-row">
                            <div class="form-group col-md-6">
                                <label>Email</label>
                                <input class="form-control" type="email" name="email" value="${bookingForm.email}">
                            </div>
                            <div class="form-group col-md-6">
                                <label>CCCD/Passport</label>
                                <input class="form-control" name="identityNumber" value="${bookingForm.identityNumber}">
                            </div>
                        </div>
                        <div class="form-group">
                            <label>Địa chỉ</label>
                            <input class="form-control" name="address" value="${bookingForm.address}">
                        </div>
                        <div class="form-group">
                            <label>Chọn phòng</label>
                            <select class="form-control" name="roomId" required>
                                <c:forEach var="r" items="${rooms}">
                                    <option value="${r.id}" ${bookingForm.roomId == r.id ? 'selected' : ''}>Phòng ${r.roomNumber} - ${r.roomType.typeName}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="form-row">
                            <div class="form-group col-md-6">
                                <label>Ngày nhận phòng</label>
                                <input class="form-control" type="text" id="bookCheckIn" name="checkInDate" value="${bookingForm.checkInDate}" placeholder="Chọn ngày" autocomplete="off" required>
                            </div>
                            <div class="form-group col-md-6">
                                <label>Ngày trả phòng</label>
                                <input class="form-control" type="text" id="bookCheckOut" name="checkOutDate" value="${bookingForm.checkOutDate}" placeholder="Chọn ngày" autocomplete="off" required>
                            </div>
                        </div>
                        <div class="form-group">
                            <label>Mã ưu đãi (nếu có)</label>
                            <input class="form-control" name="promoCode" value="${bookingForm.promoCode}" placeholder="VD: WELCOME10">
                            <c:if test="${empty currentCustomer}">
                                <small class="form-text text-muted">Mã ưu đãi áp dụng theo lịch sử đặt phòng của tài khoản. <a href="${pageContext.request.contextPath}/account/login">Đăng nhập</a> để sử dụng mã ưu đãi của bạn.</small>
                            </c:if>
                        </div>
                        <div class="form-group">
                            <label>Ghi chú</label>
                            <textarea class="form-control" name="note" rows="3">${bookingForm.note}</textarea>
                        </div>
                    </div>
                    <div class="card-footer">
                        <button class="btn btn-primary"><i class="fas fa-paper-plane mr-1"></i>Gửi đặt phòng</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<script>
    var fullyBookedDates = [
        <c:forEach var="d" items="${fullyBookedDates}">"${d}",</c:forEach>
    ];
    var bookCheckOutPicker = flatpickr("#bookCheckOut", {
        locale: "vn",
        dateFormat: "Y-m-d",
        altInput: true,
        altFormat: "d/m/Y",
        minDate: new Date().fp_incr(1),
        disable: fullyBookedDates
    });
    flatpickr("#bookCheckIn", {
        locale: "vn",
        dateFormat: "Y-m-d",
        altInput: true,
        altFormat: "d/m/Y",
        minDate: "today",
        disable: fullyBookedDates,
        onChange: function (selectedDates) {
            if (selectedDates[0]) {
                bookCheckOutPicker.set("minDate", new Date(selectedDates[0].getTime() + 86400000));
            }
        }
    });
</script>

<%@ include file="../layout/public-footer.jsp" %>
