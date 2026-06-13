<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Phòng trống" />
<%@ include file="../layout/public-header.jsp" %>

<section class="public-hero py-5">
    <div class="container text-center">
        <h1 class="h2 mb-2">Tìm phòng trống</h1>
        <p class="lead mb-0">Chọn ngày nhận - trả phòng và loại phòng để xem các phòng còn trống</p>
    </div>
</section>

<div class="container">
    <div class="card search-widget">
        <div class="card-body">
            <form action="${pageContext.request.contextPath}/rooms" method="get" class="row align-items-end">
                <div class="col-md-3 form-group mb-md-0">
                    <label>Ngày nhận phòng</label>
                    <input type="text" class="form-control" id="searchCheckIn" name="checkIn" value="${checkIn}" placeholder="Chọn ngày" autocomplete="off">
                </div>
                <div class="col-md-3 form-group mb-md-0">
                    <label>Ngày trả phòng</label>
                    <input type="text" class="form-control" id="searchCheckOut" name="checkOut" value="${checkOut}" placeholder="Chọn ngày" autocomplete="off">
                </div>
                <div class="col-md-3 form-group mb-md-0">
                    <label>Loại phòng</label>
                    <select class="form-control" name="roomTypeId">
                        <option value="">Tất cả loại phòng</option>
                        <c:forEach var="rt" items="${roomTypes}">
                            <option value="${rt.id}" ${roomTypeId == rt.id ? 'selected' : ''}>${rt.typeName}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-3 form-group mb-0">
                    <button class="btn btn-primary btn-block"><i class="fas fa-search mr-1"></i>Tìm phòng</button>
                </div>
            </form>
        </div>
    </div>
</div>

<div class="container mt-5 mb-5">
    <c:if test="${param.success == '1'}"><div class="alert alert-success">Đặt phòng thành công. Vui lòng chờ xác nhận.</div></c:if>

    <c:choose>
        <c:when test="${not empty checkIn && not empty checkOut}">
            <h2 class="mb-4">Phòng trống từ ${checkIn} đến ${checkOut}</h2>
        </c:when>
        <c:otherwise>
            <h2 class="mb-4">Danh sách phòng trống</h2>
        </c:otherwise>
    </c:choose>

    <c:if test="${empty rooms}">
        <div class="alert alert-warning">Không tìm thấy phòng phù hợp. Vui lòng thử ngày hoặc loại phòng khác.</div>
    </c:if>

    <div class="row">
        <c:forEach var="r" items="${rooms}">
            <div class="col-md-4 mb-4">
                <div class="card room-card h-100">
                    <img src="${r.roomType.getImageDisplayUrl(pageContext.request.contextPath)}" class="room-img" alt="${r.roomType.typeName}">
                    <div class="card-body d-flex flex-column">
                        <h5 class="font-weight-bold">Phòng ${r.roomNumber}</h5>
                        <p class="card-text mb-1">Loại: ${r.roomType.typeName}</p>
                        <p class="card-text mb-1">Tầng: ${r.floor}</p>
                        <p class="card-text mb-1">Tối đa: ${r.roomType.maxGuests} khách</p>
                        <p class="price">
                            <fmt:formatNumber value="${r.roomType.pricePerNight}" type="number" groupingUsed="true" /> VND/đêm
                        </p>
                        <p class="text-muted flex-grow-1">${r.description}</p>
                        <a class="btn btn-primary btn-block" href="${pageContext.request.contextPath}/booking/new?roomId=${r.id}<c:if test="${not empty checkIn}">&checkIn=${checkIn}</c:if><c:if test="${not empty checkOut}">&checkOut=${checkOut}</c:if>">Đặt phòng</a>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>
</div>

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
