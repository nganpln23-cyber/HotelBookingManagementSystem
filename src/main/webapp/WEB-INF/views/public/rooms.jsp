<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Phòng trống" />
<c:set var="solidNav" value="true" />
<%@ include file="../layout/public-header.jsp" %>

<%-- PAGE HERO --%>
<div class="ph-page-hero">
    <div class="container">
        <div class="ph-breadcrumb">
            <a href="${pageContext.request.contextPath}/">Trang chủ</a>
            <span>&rsaquo;</span> Phòng trống
        </div>
        <h1>Tìm phòng phù hợp</h1>
        <p>Chọn ngày lưu trú và loại phòng để xem các phòng đang trống</p>
    </div>
</div>

<div style="background:var(--ph-bg); padding:3rem 0 4rem;">
    <div class="container">

        <%-- FILTER BAR --%>
        <div class="ph-filter-bar">
            <form action="${pageContext.request.contextPath}/rooms" method="get">
                <div class="row align-items-end">
                    <div class="col-md-3 mb-3 mb-md-0">
                        <label><i class="fas fa-calendar-day mr-1"></i>Ngày nhận phòng</label>
                        <input type="text" class="form-control" id="searchCheckIn" name="checkIn"
                               value="${checkIn}" placeholder="Chọn ngày" autocomplete="off">
                    </div>
                    <div class="col-md-3 mb-3 mb-md-0">
                        <label><i class="fas fa-calendar-check mr-1"></i>Ngày trả phòng</label>
                        <input type="text" class="form-control" id="searchCheckOut" name="checkOut"
                               value="${checkOut}" placeholder="Chọn ngày" autocomplete="off">
                    </div>
                    <div class="col-md-3 mb-3 mb-md-0">
                        <label><i class="fas fa-layer-group mr-1"></i>Loại phòng</label>
                        <select class="form-control" name="roomTypeId">
                            <option value="">Tất cả loại phòng</option>
                            <c:forEach var="rt" items="${roomTypes}">
                                <option value="${rt.id}" ${roomTypeId == rt.id ? 'selected' : ''}>${rt.typeName}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <button type="submit" class="btn-filter">
                            <i class="fas fa-search mr-1"></i>Tìm phòng
                        </button>
                    </div>
                </div>
            </form>
        </div>

        <c:if test="${param.success == '1'}">
            <div class="ph-alert ph-alert-success mb-4">
                <i class="fas fa-check-circle mr-2"></i>Đặt phòng thành công! Chúng tôi sẽ liên hệ xác nhận sớm nhất.
            </div>
        </c:if>

        <%-- HEADING --%>
        <div class="d-flex align-items-center justify-content-between mb-4 flex-wrap gap-2">
            <div>
                <c:choose>
                    <c:when test="${not empty checkIn && not empty checkOut}">
                        <h4 style="font-family:'Playfair Display',serif;color:var(--ph-dark);font-weight:700;margin:0;">
                            Phòng trống từ <span style="color:var(--ph-gold);">${checkIn}</span>
                            đến <span style="color:var(--ph-gold);">${checkOut}</span>
                        </h4>
                    </c:when>
                    <c:otherwise>
                        <h4 style="font-family:'Playfair Display',serif;color:var(--ph-dark);font-weight:700;margin:0;">
                            Danh sách phòng trống
                        </h4>
                    </c:otherwise>
                </c:choose>
                <c:if test="${not empty rooms}">
                    <p style="color:var(--ph-muted);font-size:.88rem;margin:.25rem 0 0;">${rooms.size()} phòng tìm được</p>
                </c:if>
            </div>
        </div>

        <c:if test="${empty rooms}">
            <div class="ph-alert ph-alert-warning">
                <i class="fas fa-info-circle mr-2"></i>Không tìm thấy phòng phù hợp. Vui lòng thử ngày hoặc loại phòng khác.
            </div>
        </c:if>

        <div class="row">
            <c:forEach var="r" items="${rooms}">
                <div class="col-md-6 col-lg-4 mb-4 d-flex">
                    <div class="ph-room-card w-100">
                        <div class="ph-room-img-wrap">
                            <img src="${r.roomType.getImageDisplayUrl(pageContext.request.contextPath)}"
                                 class="ph-room-img" alt="${r.roomType.typeName}">
                            <span class="ph-room-badge">Còn trống</span>
                        </div>
                        <div class="ph-room-body">
                            <div class="ph-room-type">${r.roomType.typeName}</div>
                            <h5 class="ph-room-title">Phòng ${r.roomNumber}</h5>
                            <div class="ph-room-meta">
                                <span><i class="fas fa-layer-group"></i>Tầng ${r.floor}</span>
                                <span><i class="fas fa-user-friends"></i>Tối đa ${r.roomType.maxGuests} khách</span>
                            </div>
                            <p class="ph-room-desc">${r.description}</p>
                            <div class="ph-room-footer">
                                <div class="ph-room-price">
                                    <fmt:formatNumber value="${r.roomType.pricePerNight}" type="number" groupingUsed="true"/>
                                    <span class="ph-room-price-label"> VND/đêm</span>
                                </div>
                                <a href="${pageContext.request.contextPath}/booking/new?roomId=${r.id}<c:if test="${not empty checkIn}">&checkIn=${checkIn}</c:if><c:if test="${not empty checkOut}">&checkOut=${checkOut}</c:if>"
                                   class="btn-room-book">
                                    <i class="fas fa-calendar-plus"></i> Đặt ngay
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>
</div>

<script>
(function(){
    var fd = [<c:forEach var="d" items="${fullyBookedDates}">"${d}",</c:forEach>];
    var co = flatpickr("#searchCheckOut",{locale:"vn",dateFormat:"Y-m-d",altInput:true,altFormat:"d/m/Y",minDate:new Date().fp_incr(1),disable:fd});
    flatpickr("#searchCheckIn",{locale:"vn",dateFormat:"Y-m-d",altInput:true,altFormat:"d/m/Y",minDate:"today",disable:fd,onChange:function(d){if(d[0])co.set("minDate",new Date(d[0].getTime()+86400000));}});
})();
</script>

<%@ include file="../layout/public-footer.jsp" %>
