<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Chi tiết đặt phòng" />
<%@ include file="../layout/public-header.jsp" %>

<div class="container my-5">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1 class="h3 mb-0">Đặt phòng #${booking.id}</h1>
        <a href="${pageContext.request.contextPath}/account" class="btn btn-outline-secondary"><i class="fas fa-arrow-left mr-1"></i>Về tài khoản của tôi</a>
    </div>

    <div class="row">
        <div class="col-lg-7 mb-4">
            <div class="card mb-4">
                <div class="card-header"><i class="fas fa-bed mr-2"></i>Thông tin đặt phòng</div>
                <div class="card-body">
                    <table class="table table-borderless mb-0">
                        <tr><th style="width:180px;">Trạng thái</th><td><span class="badge badge-status-${booking.status}">${booking.status}</span></td></tr>
                        <tr><th>Phòng</th><td>${booking.roomNumber} - ${booking.roomTypeName}</td></tr>
                        <tr><th>Ngày nhận phòng</th><td>${booking.checkInDate}</td></tr>
                        <tr><th>Ngày trả phòng</th><td>${booking.checkOutDate}</td></tr>
                        <c:if test="${not empty booking.note}">
                        <tr><th>Ghi chú</th><td>${booking.note}</td></tr>
                        </c:if>
                    </table>
                </div>
            </div>

            <div class="card">
                <div class="card-header"><i class="fas fa-money-bill-wave mr-2"></i>Lịch sử thanh toán</div>
                <div class="card-body table-responsive">
                    <table class="table table-bordered table-hover mb-0">
                        <thead><tr><th>Số tiền</th><th>Phương thức</th><th>Trạng thái</th><th>Thời gian</th></tr></thead>
                        <tbody>
                        <c:forEach var="p" items="${payments}">
                            <tr>
                                <td><fmt:formatNumber value="${p.amount}" type="number" groupingUsed="true"/> VND</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${p.method == 'CASH'}">Tiền mặt</c:when>
                                        <c:when test="${p.method == 'CARD'}">Thẻ</c:when>
                                        <c:when test="${p.method == 'BANK_TRANSFER'}">Chuyển khoản</c:when>
                                        <c:when test="${p.method == 'EWALLET'}">Ví điện tử</c:when>
                                        <c:otherwise>${p.method}</c:otherwise>
                                    </c:choose>
                                </td>
                                <td><span class="badge badge-status-${p.status}">${p.status}</span></td>
                                <td><fmt:formatDate value="${p.paidAt}" pattern="dd/MM/yyyy HH:mm"/></td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty payments}">
                            <tr><td colspan="4" class="text-center text-muted">Chưa có thanh toán nào được ghi nhận.</td></tr>
                        </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <div class="col-lg-5">
            <div class="card">
                <div class="card-header"><i class="fas fa-receipt mr-2"></i>Tổng kết hóa đơn</div>
                <div class="card-body">
                    <table class="table table-borderless mb-0">
                        <tr><th>Tạm tính</th><td class="text-right"><fmt:formatNumber value="${booking.totalAmount + booking.discountAmount}" type="number" groupingUsed="true"/> VND</td></tr>
                        <c:if test="${booking.discountAmount > 0}">
                        <tr>
                            <th>Giảm giá <span class="promo-code">${booking.promoCode}</span></th>
                            <td class="text-right text-success">-<fmt:formatNumber value="${booking.discountAmount}" type="number" groupingUsed="true"/> VND</td>
                        </tr>
                        </c:if>
                        <tr class="font-weight-bold"><th>Tổng tiền</th><td class="text-right"><fmt:formatNumber value="${booking.totalAmount}" type="number" groupingUsed="true"/> VND</td></tr>
                        <tr>
                            <th>Còn phải thanh toán</th>
                            <td class="text-right font-weight-bold ${amountDue > 0 ? 'text-danger' : 'text-success'}"><fmt:formatNumber value="${amountDue}" type="number" groupingUsed="true"/> VND</td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="../layout/public-footer.jsp" %>
