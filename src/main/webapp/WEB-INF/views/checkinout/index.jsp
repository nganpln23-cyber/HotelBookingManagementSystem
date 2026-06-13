<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Check-in / Check-out" />
<%@ include file="../layout/header.jsp" %>

<div class="card">
    <div class="card-header"><i class="fas fa-door-open mr-2"></i>Khách chờ check-in</div>
    <div class="card-body table-responsive">
        <table class="table table-bordered table-hover">
            <thead>
            <tr><th>ID</th><th>Khách</th><th>Phòng</th><th>Ngày nhận</th><th>Ngày trả</th><th>Trạng thái</th><th width="140">Thao tác</th></tr>
            </thead>
            <tbody>
            <c:forEach var="b" items="${confirmedBookings}">
                <tr>
                    <td>${b.id}</td>
                    <td>${b.customerName}</td>
                    <td>${b.roomNumber} - ${b.roomTypeName}</td>
                    <td>${b.checkInDate}</td>
                    <td>${b.checkOutDate}</td>
                    <td><span class="badge badge-status-${b.status}">${b.status}</span></td>
                    <td>
                        <a class="btn btn-sm btn-primary" href="${pageContext.request.contextPath}/admin/checkinout/check-in/${b.id}">
                            <i class="fas fa-sign-in-alt mr-1"></i>Check-in
                        </a>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty confirmedBookings}">
                <tr><td colspan="7" class="text-center text-muted">Không có booking nào chờ check-in.</td></tr>
            </c:if>
            </tbody>
        </table>
    </div>
</div>

<div class="card">
    <div class="card-header"><i class="fas fa-bed mr-2"></i>Khách đang ở - chờ check-out</div>
    <div class="card-body table-responsive">
        <table class="table table-bordered table-hover">
            <thead>
            <tr><th>ID</th><th>Khách</th><th>Phòng</th><th>Ngày nhận</th><th>Ngày trả</th><th>Còn phải thu</th><th width="180">Thao tác</th></tr>
            </thead>
            <tbody>
            <c:forEach var="b" items="${checkedInBookings}">
                <tr>
                    <td>${b.id}</td>
                    <td>${b.customerName}</td>
                    <td>${b.roomNumber} - ${b.roomTypeName}</td>
                    <td>${b.checkInDate}</td>
                    <td>${b.checkOutDate}</td>
                    <td>
                        <c:choose>
                            <c:when test="${fullyPaidMap[b.id]}">
                                <span class="badge badge-status-PAID">Đã thanh toán</span>
                            </c:when>
                            <c:otherwise>
                                <strong class="text-danger"><fmt:formatNumber value="${amountDueMap[b.id]}" type="number" groupingUsed="true" /> VND</strong>
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <c:choose>
                            <c:when test="${fullyPaidMap[b.id]}">
                                <a class="btn btn-sm btn-success" href="${pageContext.request.contextPath}/admin/checkinout/check-out/${b.id}">
                                    <i class="fas fa-sign-out-alt mr-1"></i>Check-out
                                </a>
                            </c:when>
                            <c:otherwise>
                                <a class="btn btn-sm btn-warning" href="${pageContext.request.contextPath}/admin/checkinout/check-out/${b.id}">
                                    <i class="fas fa-money-bill-wave mr-1"></i>Thanh toán &amp; Check-out
                                </a>
                            </c:otherwise>
                        </c:choose>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty checkedInBookings}">
                <tr><td colspan="7" class="text-center text-muted">Không có khách nào đang ở.</td></tr>
            </c:if>
            </tbody>
        </table>
    </div>
</div>
<%@ include file="../layout/footer.jsp" %>
