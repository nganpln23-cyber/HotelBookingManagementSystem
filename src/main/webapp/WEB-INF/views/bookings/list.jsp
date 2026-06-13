<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Quản lý đặt phòng" />
<%@ include file="../layout/header.jsp" %>
<div class="card">
    <div class="card-header"><a href="${pageContext.request.contextPath}/admin/bookings/new" class="btn btn-primary btn-sm"><i class="fas fa-plus"></i> Tạo booking</a></div>
    <div class="card-body table-responsive">
        <table class="table table-bordered table-hover">
            <thead>
            <tr><th>ID</th><th>Khách</th><th>Phòng</th><th>Ngày vào</th><th>Ngày ra</th><th>Trạng thái</th><th>Tổng tiền</th><th width="330">Thao tác</th></tr>
            </thead>
            <tbody>
            <c:forEach var="b" items="${bookings}">
                <tr>
                    <td>${b.id}</td>
                    <td>${b.customerName}</td>
                    <td>${b.roomNumber} - ${b.roomTypeName}</td>
                    <td>${b.checkInDate}</td>
                    <td>${b.checkOutDate}</td>
                    <td><span class="badge badge-status-${b.status}">${b.status}</span></td>
                    <td><fmt:formatNumber value="${b.totalAmount}" type="number" groupingUsed="true" /> VND</td>
                    <td>
                        <c:if test="${b.status == 'PENDING'}">
                            <a class="btn btn-sm btn-success" href="${pageContext.request.contextPath}/admin/bookings/confirm/${b.id}">Confirm</a>
                        </c:if>
                        <c:if test="${b.status == 'CONFIRMED'}">
                            <a class="btn btn-sm btn-info" href="${pageContext.request.contextPath}/admin/bookings/check-in/${b.id}">Check-in</a>
                        </c:if>
                        <c:if test="${b.status == 'CHECKED_IN'}">
                            <a class="btn btn-sm btn-secondary" href="${pageContext.request.contextPath}/admin/bookings/check-out/${b.id}">Check-out</a>
                        </c:if>
                        <c:if test="${b.status == 'PENDING' || b.status == 'CONFIRMED'}">
                            <a class="btn btn-sm btn-dark" onclick="return confirm('Hủy booking này?')" href="${pageContext.request.contextPath}/admin/bookings/cancel/${b.id}">Hủy</a>
                        </c:if>
                        <c:if test="${b.status == 'CONFIRMED' || b.status == 'CHECKED_IN' || b.status == 'CHECKED_OUT'}">
                            <a class="btn btn-sm btn-primary" href="${pageContext.request.contextPath}/admin/payments/new/${b.id}"><i class="fas fa-money-bill-wave"></i> Thanh toán</a>
                        </c:if>
                        <a class="btn btn-sm btn-warning" href="${pageContext.request.contextPath}/admin/bookings/edit/${b.id}">Sửa</a>
                        <c:if test="${b.status != 'CONFIRMED' && b.status != 'CHECKED_IN'}">
                            <a class="btn btn-sm btn-danger" onclick="return confirm('Xóa booking này?')" href="${pageContext.request.contextPath}/admin/bookings/delete/${b.id}">Xóa</a>
                        </c:if>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
</div>
<%@ include file="../layout/footer.jsp" %>
