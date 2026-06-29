<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Check-in / Check-out" />
<%@ include file="../layout/header.jsp" %>

<%-- Stat bar --%>
<div class="row mb-4">
    <div class="col-md-6 mb-3">
        <div class="stat-card stat-indigo">
            <div class="stat-icon stat-icon-indigo"><i class="fas fa-sign-in-alt"></i></div>
            <div>
                <div class="stat-value">${confirmedBookings.size()}</div>
                <div class="stat-label">Chờ check-in</div>
            </div>
        </div>
    </div>
    <div class="col-md-6 mb-3">
        <div class="stat-card stat-green">
            <div class="stat-icon stat-icon-green"><i class="fas fa-bed"></i></div>
            <div>
                <div class="stat-value">${checkedInBookings.size()}</div>
                <div class="stat-label">Đang ở khách sạn</div>
            </div>
        </div>
    </div>
</div>

<%-- Check-in table --%>
<div class="card mb-4">
    <div class="card-header">
        <i class="fas fa-sign-in-alt" style="color:#4f46e5;"></i> Khách chờ check-in
        <span class="badge" style="background:var(--brand-light);color:var(--brand);margin-left:auto;">${confirmedBookings.size()}</span>
    </div>
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
                    <th>Mã đặt</th>
                    <th>Thao tác</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="b" items="${confirmedBookings}">
                    <tr>
                        <td class="text-muted" style="font-size:.78rem;">#${b.id}</td>
                        <td style="font-weight:600;">${b.customerName}</td>
                        <td>
                            <strong>${b.roomNumber}</strong>
                            <span class="text-muted" style="font-size:.78rem;"> &middot; ${b.roomTypeName}</span>
                        </td>
                        <td>
                            <i class="fas fa-calendar-day mr-1" style="color:#4f46e5;font-size:.75rem;"></i>${b.checkInDate}
                        </td>
                        <td>${b.checkOutDate}</td>
                        <td>
                            <c:if test="${not empty b.confirmationCode}">
                                <span class="code-chip code-confirm">
                                    <i class="fas fa-barcode" style="font-size:.62rem;"></i>${b.confirmationCode}
                                </span>
                            </c:if>
                            <c:if test="${empty b.confirmationCode}"><span class="text-muted">—</span></c:if>
                        </td>
                        <td>
                            <div class="action-btn-group">
                                <a class="btn btn-sm btn-primary"
                                   href="${pageContext.request.contextPath}/admin/checkinout/check-in/${b.id}">
                                    <i class="fas fa-sign-in-alt"></i> Check-in
                                </a>
                                <a class="btn btn-sm btn-bill"
                                   href="${pageContext.request.contextPath}/admin/bookings/invoice/${b.id}"
                                   target="_blank" title="In hóa đơn">
                                    <i class="fas fa-print"></i>
                                </a>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty confirmedBookings}">
                    <tr>
                        <td colspan="7" class="text-center text-muted py-5">
                            <i class="fas fa-check-circle fa-2x mb-2 d-block" style="color:#10b981;"></i>
                            Không có khách nào chờ check-in.
                        </td>
                    </tr>
                </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>

<%-- Check-out table --%>
<div class="card">
    <div class="card-header">
        <i class="fas fa-sign-out-alt" style="color:#10b981;"></i> Khách đang ở &mdash; chờ check-out
        <span class="badge" style="background:#d1fae5;color:#065f46;margin-left:auto;">${checkedInBookings.size()}</span>
    </div>
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
                    <th>Mã nhận phòng</th>
                    <th>Thanh toán</th>
                    <th>Thao tác</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="b" items="${checkedInBookings}">
                    <tr>
                        <td class="text-muted" style="font-size:.78rem;">#${b.id}</td>
                        <td style="font-weight:600;">${b.customerName}</td>
                        <td>
                            <strong>${b.roomNumber}</strong>
                            <span class="text-muted" style="font-size:.78rem;"> &middot; ${b.roomTypeName}</span>
                        </td>
                        <td>${b.checkInDate}</td>
                        <td>${b.checkOutDate}</td>
                        <td>
                            <c:if test="${not empty b.checkinCode}">
                                <span class="code-chip code-checkin">
                                    <i class="fas fa-key" style="font-size:.62rem;"></i>${b.checkinCode}
                                </span>
                            </c:if>
                            <c:if test="${empty b.checkinCode}"><span class="text-muted">—</span></c:if>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${fullyPaidMap[b.id]}">
                                    <span class="badge badge-status-PAID"><i class="fas fa-check" style="font-size:.6rem;"></i> Đã thanh toán</span>
                                </c:when>
                                <c:otherwise>
                                    <span style="font-weight:700;color:#dc2626;font-size:.875rem;">
                                        <fmt:formatNumber value="${amountDueMap[b.id]}" type="number" groupingUsed="true" />đ
                                    </span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <div class="action-btn-group">
                                <c:choose>
                                    <c:when test="${fullyPaidMap[b.id]}">
                                        <a class="btn btn-sm btn-success"
                                           href="${pageContext.request.contextPath}/admin/checkinout/check-out/${b.id}">
                                            <i class="fas fa-sign-out-alt"></i> Check-out
                                        </a>
                                    </c:when>
                                    <c:otherwise>
                                        <a class="btn btn-sm btn-warning"
                                           href="${pageContext.request.contextPath}/admin/payments/new/${b.id}?redirectAction=checkout">
                                            <i class="fas fa-money-bill-wave"></i> Thanh toán &amp; Check-out
                                        </a>
                                    </c:otherwise>
                                </c:choose>
                                <a class="btn btn-sm btn-bill"
                                   href="${pageContext.request.contextPath}/admin/bookings/invoice/${b.id}"
                                   target="_blank" title="In hóa đơn">
                                    <i class="fas fa-print"></i>
                                </a>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty checkedInBookings}">
                    <tr>
                        <td colspan="8" class="text-center text-muted py-5">
                            <i class="fas fa-moon fa-2x mb-2 d-block" style="color:#94a3b8;"></i>
                            Không có khách nào đang ở.
                        </td>
                    </tr>
                </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script>
(function () {
    var y = sessionStorage.getItem('checkinoutScrollY');
    if (y) { window.scrollTo(0, parseInt(y)); sessionStorage.removeItem('checkinoutScrollY'); }
})();
document.querySelectorAll('.action-btn-group a').forEach(function (a) {
    a.addEventListener('click', function () {
        sessionStorage.setItem('checkinoutScrollY', window.scrollY);
    });
});
</script>
<%@ include file="../layout/footer.jsp" %>
