<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Thanh toán" />
<%@ include file="../layout/header.jsp" %>
<div class="card">
    <div class="card-header"><i class="fas fa-money-bill-wave mr-2"></i>Lịch sử thanh toán</div>
    <div class="card-body table-responsive">
        <table class="table table-bordered table-hover">
            <thead>
            <tr><th>ID</th><th>Booking</th><th>Khách</th><th>Phòng</th><th>Số tiền</th><th>Phương thức</th><th>Trạng thái</th><th>Thời gian</th><th>Ghi chú</th></tr>
            </thead>
            <tbody>
            <c:forEach var="p" items="${payments}">
                <tr>
                    <td>${p.id}</td>
                    <td>#${p.bookingId}</td>
                    <td>${p.customerName}</td>
                    <td>${p.roomNumber}</td>
                    <td><fmt:formatNumber value="${p.amount}" type="number" groupingUsed="true" /> VND</td>
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
                    <td><fmt:formatDate value="${p.paidAt}" pattern="dd/MM/yyyy HH:mm" /></td>
                    <td>${p.note}</td>
                </tr>
            </c:forEach>
            <c:if test="${empty payments}">
                <tr><td colspan="9" class="text-center text-muted">Chưa có giao dịch thanh toán nào.</td></tr>
            </c:if>
            </tbody>
        </table>
    </div>
</div>
<%@ include file="../layout/footer.jsp" %>
