<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Quản lý đặt phòng" />
<%@ include file="../layout/header.jsp" %>

<div class="d-flex align-items-center justify-content-between mb-3" style="gap:.5rem;flex-wrap:wrap;">
    <div class="d-flex" style="gap:.5rem;">
        <a href="${pageContext.request.contextPath}/admin/bookings/new" class="btn btn-primary btn-sm">
            <i class="fas fa-plus"></i> Tạo booking
        </a>
        <a href="${pageContext.request.contextPath}/admin/bookings/calendar" class="btn btn-outline-primary btn-sm">
            <i class="fas fa-calendar-alt"></i> Xem lịch
        </a>
    </div>
    <div class="d-flex align-items-center" style="gap:.4rem;flex-wrap:wrap;">
        <input type="text" id="bookingSearch" class="form-control form-control-sm" placeholder="Tìm khách, phòng, mã đặt..." style="width:230px;" oninput="filterBookings(this.value)">
        <select id="statusFilter" class="form-control form-control-sm" style="width:180px;" onchange="filterBookings(document.getElementById('bookingSearch').value)">
            <option value="">-- Tất cả trạng thái --</option>
            <option value="AWAITING_PAYMENT">Chờ thanh toán online</option>
            <option value="PENDING">Chờ xác nhận</option>
            <option value="CONFIRMED">Đã xác nhận</option>
            <option value="CHECKED_IN">Đang ở</option>
            <option value="CHECKED_OUT">Đã trả phòng</option>
            <option value="CANCELLED">Đã hủy</option>
        </select>
    </div>
</div>

<div class="card">
    <div class="card-body p-0">
        <div class="table-responsive">
            <table class="table table-hover mb-0">
                <thead>
                <tr>
                    <th>#</th>
                    <th>Khách hàng</th>
                    <th>Phòng</th>
                    <th>Nhận phòng</th>
                    <th>Trả phòng</th>
                    <th>Trạng thái</th>
                    <th>Mã đặt</th>
                    <th>Tổng tiền</th>
                    <th style="min-width:260px;">Thao tác</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="b" items="${bookings}">
                    <tr id="booking-row-${b.id}" data-customer="${b.customerName}" data-room="${b.roomNumber}" data-code="${b.confirmationCode} ${b.checkinCode}" data-status="${b.status}">
                        <td class="text-muted" style="font-size:.78rem;">#${b.id}</td>
                        <td>
                            <div style="font-weight:600;">${b.customerName}</div>
                        </td>
                        <td>
                            <div style="font-weight:600;">${b.roomNumber}</div>
                            <div style="font-size:.75rem;color:#64748b;">${b.roomTypeName}</div>
                        </td>
                        <td style="white-space:nowrap;">
                            <i class="fas fa-sign-in-alt mr-1" style="color:#4f46e5;font-size:.75rem;"></i>${b.checkInDate}
                        </td>
                        <td style="white-space:nowrap;">
                            <i class="fas fa-sign-out-alt mr-1" style="color:#64748b;font-size:.75rem;"></i>${b.checkOutDate}
                        </td>
                        <td>
                            <span class="badge badge-status-${b.status}">
                                <c:choose>
                                    <c:when test="${b.status == 'AWAITING_PAYMENT'}"><i class="fas fa-spinner fa-spin mr-1"></i>Chờ TT</c:when>
                                    <c:otherwise>${b.status}</c:otherwise>
                                </c:choose>
                            </span>
                            <c:if test="${b.onlinePaid}">
                                <span class="badge" style="background:#dbeafe;color:#1d4ed8;font-size:.65rem;margin-left:3px;">
                                    <i class="fas fa-credit-card mr-1"></i>Online
                                </span>
                            </c:if>
                        </td>
                        <td>
                            <c:if test="${not empty b.confirmationCode}">
                                <span class="code-chip code-confirm">
                                    <i class="fas fa-barcode" style="font-size:.65rem;"></i>${b.confirmationCode}
                                </span>
                            </c:if>
                            <c:if test="${not empty b.checkinCode}">
                                <br><span class="code-chip code-checkin mt-1">
                                    <i class="fas fa-key" style="font-size:.65rem;"></i>${b.checkinCode}
                                </span>
                            </c:if>
                            <c:if test="${empty b.confirmationCode && empty b.checkinCode}">
                                <span class="text-muted" style="font-size:.75rem;">—</span>
                            </c:if>
                        </td>
                        <td style="white-space:nowrap;font-weight:600;">
                            <fmt:formatNumber value="${b.totalAmount}" type="number" groupingUsed="true" />đ
                        </td>
                        <td>
                            <div class="action-btn-group">
                                <c:if test="${b.status == 'AWAITING_PAYMENT'}">
                                    <span class="badge" style="background:#fef3c7;color:#92400e;font-size:.72rem;padding:.35rem .6rem;">
                                        <i class="fas fa-hourglass-half mr-1"></i>Đang thanh toán online
                                    </span>
                                    <a class="btn btn-sm btn-danger"
                                       onclick="return confirm('Hủy booking #${b.id}? Khách đang trong quá trình thanh toán.')"
                                       href="${pageContext.request.contextPath}/admin/bookings/cancel/${b.id}"
                                       title="Hủy booking">
                                        <i class="fas fa-times"></i> Hủy
                                    </a>
                                </c:if>
                                <c:if test="${b.status == 'PENDING'}">
                                    <a class="btn btn-sm btn-confirm"
                                       href="${pageContext.request.contextPath}/admin/bookings/confirm/${b.id}"
                                       title="${b.onlinePaid ? 'Xác nhận &amp; gửi email cho khách' : 'Xác nhận booking'}">
                                        <i class="fas ${b.onlinePaid ? 'fa-paper-plane' : 'fa-check'}"></i>
                                        Xác nhận<c:if test="${b.onlinePaid}"> &amp; Email</c:if>
                                    </a>
                                    <a class="btn btn-sm btn-danger"
                                       onclick="return confirm('Hủy booking #${b.id}?')"
                                       href="${pageContext.request.contextPath}/admin/bookings/cancel/${b.id}"
                                       title="Hủy booking">
                                        <i class="fas fa-times"></i> Hủy
                                    </a>
                                </c:if>
                                <c:if test="${b.status == 'CONFIRMED'}">
                                    <a class="btn btn-sm btn-danger"
                                       onclick="return confirm('Hủy booking #${b.id}? Phòng sẽ được giải phóng.')"
                                       href="${pageContext.request.contextPath}/admin/bookings/cancel/${b.id}"
                                       title="Hủy booking đã xác nhận">
                                        <i class="fas fa-times"></i> Hủy
                                    </a>
                                </c:if>
                                <c:if test="${b.status == 'CONFIRMED'}">
                                    <a class="btn btn-sm btn-checkin"
                                       href="${pageContext.request.contextPath}/admin/bookings/check-in/${b.id}"
                                       title="Check In">
                                        <i class="fas fa-sign-in-alt"></i> Check In
                                    </a>
                                </c:if>
                                <c:if test="${b.status == 'CHECKED_IN'}">
                                    <c:choose>
                                        <c:when test="${fullyPaidMap[b.id]}">
                                            <a class="btn btn-sm btn-success"
                                               href="${pageContext.request.contextPath}/admin/bookings/check-out/${b.id}"
                                               title="Check-out">
                                                <i class="fas fa-sign-out-alt"></i> Check-out
                                            </a>
                                        </c:when>
                                        <c:otherwise>
                                            <a class="btn btn-sm btn-pay"
                                               href="${pageContext.request.contextPath}/admin/payments/new/${b.id}?redirectAction=checkout"
                                               title="Thanh toán &amp; Check-out">
                                                <i class="fas fa-money-bill-wave"></i> Thanh toán &amp; Check-out
                                            </a>
                                        </c:otherwise>
                                    </c:choose>
                                </c:if>
                                <c:if test="${b.status == 'CONFIRMED' || b.status == 'CHECKED_OUT'}">
                                    <a class="btn btn-sm btn-pay"
                                       href="${pageContext.request.contextPath}/admin/payments/new/${b.id}"
                                       title="Thanh toán">
                                        <i class="fas fa-money-bill-wave"></i>
                                    </a>
                                </c:if>
                                <a class="btn btn-sm btn-bill"
                                   href="${pageContext.request.contextPath}/admin/bookings/invoice/${b.id}"
                                   title="In hóa đơn" target="_blank">
                                    <i class="fas fa-print"></i>
                                </a>
                                <a class="btn btn-sm btn-light"
                                   href="${pageContext.request.contextPath}/admin/bookings/edit/${b.id}"
                                   title="Chỉnh sửa">
                                    <i class="fas fa-pen"></i>
                                </a>
                                <c:if test="${b.status != 'CONFIRMED' && b.status != 'CHECKED_IN'}">
                                    <a class="btn btn-sm btn-danger"
                                       onclick="return confirm('Xóa booking #${b.id}?')"
                                       href="${pageContext.request.contextPath}/admin/bookings/delete/${b.id}"
                                       title="Xóa">
                                        <i class="fas fa-trash"></i>
                                    </a>
                                </c:if>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty bookings}">
                    <tr>
                        <td colspan="9" class="text-center text-muted py-5">
                            <i class="fas fa-calendar-times fa-2x mb-3 d-block"></i>
                            Chưa có đặt phòng nào.
                        </td>
                    </tr>
                </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script>
// Restore scroll position after action redirect
(function () {
    var y = sessionStorage.getItem('bookingListScrollY');
    if (y) { window.scrollTo(0, parseInt(y)); sessionStorage.removeItem('bookingListScrollY'); }
})();

document.querySelectorAll('.action-btn-group a').forEach(function (a) {
    a.addEventListener('click', function () {
        sessionStorage.setItem('bookingListScrollY', window.scrollY);
    });
});

// Live search + status filter
function filterBookings(keyword) {
    var kw = keyword.toLowerCase().trim();
    var st = document.getElementById('statusFilter').value;
    document.querySelectorAll('tr[id^="booking-row-"]').forEach(function (tr) {
        var matchKw = !kw
            || (tr.dataset.customer || '').toLowerCase().includes(kw)
            || (tr.dataset.room || '').toLowerCase().includes(kw)
            || (tr.dataset.code || '').toLowerCase().includes(kw);
        var matchSt = !st || tr.dataset.status === st;
        tr.style.display = (matchKw && matchSt) ? '' : 'none';
    });
}
</script>

<%@ include file="../layout/footer.jsp" %>
