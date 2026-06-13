<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Trang chủ" />
<%@ include file="../layout/public-header.jsp" %>

<section class="public-hero">
    <div class="container text-center">
        <span class="badge badge-pill badge-light text-uppercase px-3 py-2 mb-3">Chào mừng đến với Hotel Booking</span>
        <h1 class="display-4">Kỳ nghỉ trong mơ bắt đầu từ đây</h1>
        <p class="lead mx-auto" style="max-width: 640px;">Hệ thống đặt phòng trực tuyến nhanh chóng, tiện lợi với đầy đủ tiện nghi cao cấp và mức giá tốt nhất dành cho bạn.</p>
    </div>
</section>

<div class="container">
    <div class="card search-widget">
        <div class="card-body">
            <form action="${pageContext.request.contextPath}/rooms" method="get" class="row align-items-end">
                <div class="col-md-3 form-group mb-md-0">
                    <label>Ngày nhận phòng</label>
                    <input type="text" class="form-control" id="searchCheckIn" name="checkIn" placeholder="Chọn ngày" autocomplete="off" required>
                </div>
                <div class="col-md-3 form-group mb-md-0">
                    <label>Ngày trả phòng</label>
                    <input type="text" class="form-control" id="searchCheckOut" name="checkOut" placeholder="Chọn ngày" autocomplete="off" required>
                </div>
                <div class="col-md-3 form-group mb-md-0">
                    <label>Loại phòng</label>
                    <select class="form-control" name="roomTypeId">
                        <option value="">Tất cả loại phòng</option>
                        <c:forEach var="rt" items="${roomTypes}">
                            <option value="${rt.id}">${rt.typeName}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-3 form-group mb-0">
                    <button class="btn btn-primary btn-block"><i class="fas fa-search mr-1"></i>Tìm phòng trống</button>
                </div>
            </form>
        </div>
    </div>
</div>

<div class="container mt-5 pt-3">
    <div class="row align-items-center">
        <div class="col-md-6 mb-4 mb-md-0">
            <img src="https://images.unsplash.com/photo-1564501049412-61c2a3083791?w=900&q=80" class="img-fluid rounded shadow-sm" alt="Sảnh khách sạn">
        </div>
        <div class="col-md-6">
            <h2 class="section-title">Về chúng tôi</h2>
            <p class="text-muted">Tọa lạc tại vị trí trung tâm thuận tiện di chuyển, khách sạn của chúng tôi mang đến không gian nghỉ dưỡng sang trọng,
                ấm cúng cùng dịch vụ tận tâm. Dù bạn đi công tác hay du lịch cùng gia đình, chúng tôi luôn có lựa chọn phòng phù hợp với nhu cầu của bạn.</p>
            <ul class="list-unstyled">
                <li class="mb-2"><i class="fas fa-check-circle text-success mr-2"></i>Nhận phòng / trả phòng linh hoạt</li>
                <li class="mb-2"><i class="fas fa-check-circle text-success mr-2"></i>Đội ngũ lễ tân hỗ trợ 24/7</li>
                <li class="mb-2"><i class="fas fa-check-circle text-success mr-2"></i>Đặt phòng trực tuyến, xác nhận nhanh chóng</li>
                <li class="mb-0"><i class="fas fa-check-circle text-success mr-2"></i>Giá tốt nhất, không phụ phí ẩn</li>
            </ul>
        </div>
    </div>
</div>

<div class="container mt-5 pt-3 text-center">
    <h2 class="section-title">Tiện nghi nổi bật</h2>
    <p class="section-subtitle">Trải nghiệm dịch vụ đẳng cấp trong suốt kỳ nghỉ của bạn</p>
    <div class="row">
        <div class="col-6 col-md-3 mb-4">
            <div class="amenity-card">
                <div class="amenity-icon"><i class="fas fa-wifi"></i></div>
                <h6 class="font-weight-bold mb-1">Wifi miễn phí</h6>
                <p class="text-muted small mb-0">Tốc độ cao trong toàn khách sạn</p>
            </div>
        </div>
        <div class="col-6 col-md-3 mb-4">
            <div class="amenity-card">
                <div class="amenity-icon"><i class="fas fa-swimming-pool"></i></div>
                <h6 class="font-weight-bold mb-1">Hồ bơi</h6>
                <p class="text-muted small mb-0">Hồ bơi ngoài trời view đẹp</p>
            </div>
        </div>
        <div class="col-6 col-md-3 mb-4">
            <div class="amenity-card">
                <div class="amenity-icon"><i class="fas fa-parking"></i></div>
                <h6 class="font-weight-bold mb-1">Bãi đỗ xe</h6>
                <p class="text-muted small mb-0">Miễn phí cho khách lưu trú</p>
            </div>
        </div>
        <div class="col-6 col-md-3 mb-4">
            <div class="amenity-card">
                <div class="amenity-icon"><i class="fas fa-utensils"></i></div>
                <h6 class="font-weight-bold mb-1">Nhà hàng</h6>
                <p class="text-muted small mb-0">Ẩm thực đa dạng, phục vụ tận phòng</p>
            </div>
        </div>
    </div>
</div>

<div class="container mt-5 pt-3">
    <div class="text-center">
        <h2 class="section-title">Hạng phòng</h2>
        <p class="section-subtitle">Lựa chọn không gian nghỉ dưỡng phù hợp với bạn</p>
    </div>
    <div class="row">
        <c:forEach var="rt" items="${roomTypes}">
            <div class="col-md-4 mb-4">
                <div class="card room-card h-100">
                    <img src="${rt.getImageDisplayUrl(pageContext.request.contextPath)}" class="room-img" alt="${rt.typeName}">
                    <div class="card-body d-flex flex-column">
                        <h5 class="font-weight-bold">${rt.typeName}</h5>
                        <p class="text-muted flex-grow-1">${rt.description}</p>
                        <p class="text-muted small mb-2"><i class="fas fa-user-friends mr-1"></i>Tối đa ${rt.maxGuests} khách</p>
                        <p class="price mb-3"><fmt:formatNumber value="${rt.pricePerNight}" type="number" groupingUsed="true" /> VND/đêm</p>
                        <a href="${pageContext.request.contextPath}/rooms?roomTypeId=${rt.id}" class="btn btn-outline-primary btn-block">Xem phòng</a>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>
</div>

<div class="container mt-5 pt-3 mb-5">
    <div class="text-center">
        <h2 class="section-title">Phòng đang trống</h2>
        <p class="section-subtitle">Một vài phòng nổi bật đang sẵn sàng đón bạn</p>
    </div>
    <div class="row">
        <c:forEach var="r" items="${rooms}" begin="0" end="2">
            <div class="col-md-4 mb-4">
                <div class="card room-card h-100">
                    <img src="${r.roomType.getImageDisplayUrl(pageContext.request.contextPath)}" class="room-img" alt="${r.roomType.typeName}">
                    <div class="card-body d-flex flex-column">
                        <h5 class="font-weight-bold">Phòng ${r.roomNumber}</h5>
                        <p class="text-muted mb-2 flex-grow-1">${r.roomType.typeName} &middot; tối đa ${r.roomType.maxGuests} khách</p>
                        <p class="price mb-3"><fmt:formatNumber value="${r.roomType.pricePerNight}" type="number" groupingUsed="true" /> VND/đêm</p>
                        <a href="${pageContext.request.contextPath}/booking/new?roomId=${r.id}" class="btn btn-primary btn-block">Đặt phòng</a>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>
    <div class="text-center mt-2">
        <a href="${pageContext.request.contextPath}/rooms" class="btn btn-outline-primary">Xem tất cả phòng <i class="fas fa-arrow-right ml-1"></i></a>
    </div>
</div>

<section class="cta-section text-center">
    <div class="container">
        <h2>Sẵn sàng cho kỳ nghỉ tiếp theo?</h2>
        <p class="lead">Đặt phòng ngay hôm nay để được phục vụ tốt nhất</p>
        <a href="${pageContext.request.contextPath}/booking/new" class="btn btn-light btn-lg"><i class="fas fa-calendar-check mr-1"></i>Đặt phòng ngay</a>
    </div>
</section>

<script>
    var fullyBookedDates = [
        <c:forEach var="d" items="${fullyBookedDates}">"${d}",</c:forEach>
    ];
    var checkOutPicker = flatpickr("#searchCheckOut", {
        locale: "vn",
        dateFormat: "Y-m-d",
        altInput: true,
        altFormat: "d/m/Y",
        minDate: new Date().fp_incr(1),
        disable: fullyBookedDates
    });
    flatpickr("#searchCheckIn", {
        locale: "vn",
        dateFormat: "Y-m-d",
        altInput: true,
        altFormat: "d/m/Y",
        minDate: "today",
        disable: fullyBookedDates,
        onChange: function (selectedDates) {
            if (selectedDates[0]) {
                checkOutPicker.set("minDate", new Date(selectedDates[0].getTime() + 86400000));
            }
        }
    });
</script>

<%@ include file="../layout/public-footer.jsp" %>
