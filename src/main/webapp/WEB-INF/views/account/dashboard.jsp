<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Tài khoản của tôi" />
<%@ include file="../layout/public-header.jsp" %>

<section class="public-hero py-5">
    <div class="container">
        <h1 class="h2 mb-1">Xin chào, ${customer.fullName}</h1>
        <p class="lead mb-0">Theo dõi lịch sử đặt phòng, hóa đơn và ưu đãi của bạn</p>
    </div>
</section>

<div class="container my-5">
    <div class="row mb-4">
        <div class="col-md-4 mb-3">
            <div class="stat-card">
                <div class="stat-icon stat-icon-indigo"><i class="fas fa-calendar-check"></i></div>
                <div>
                    <div class="stat-value">${bookings.size()}</div>
                    <div class="stat-label">Tổng số lượt đặt phòng</div>
                </div>
            </div>
        </div>
        <div class="col-md-4 mb-3">
            <div class="stat-card">
                <div class="stat-icon stat-icon-cyan"><i class="fas fa-id-card"></i></div>
                <div>
                    <div class="stat-value" style="font-size:1.05rem;">${customer.email}</div>
                    <div class="stat-label">${customer.phone}</div>
                </div>
            </div>
        </div>
        <div class="col-md-4 mb-3">
            <div class="stat-card">
                <div class="stat-icon stat-icon-amber"><i class="fas fa-gift"></i></div>
                <div>
                    <div class="stat-value">${promotions.size()}</div>
                    <div class="stat-label">Mã ưu đãi khả dụng</div>
                </div>
            </div>
        </div>
    </div>

    <c:if test="${not empty promotions}">
    <div class="card mb-4">
        <div class="card-header"><i class="fas fa-gift mr-2"></i>Ưu đãi dành cho bạn</div>
        <div class="card-body">
            <div class="row">
                <c:forEach var="promo" items="${promotions}">
                    <div class="col-md-6 mb-3">
                        <div class="promo-card p-3">
                            <div class="d-flex justify-content-between align-items-center mb-1">
                                <span class="promo-code">${promo.code}</span>
                                <span class="font-weight-bold text-brand">-${promo.discountPercent}%</span>
                            </div>
                            <p class="text-muted mb-0 small">${promo.description}</p>
                        </div>
                    </div>
                </c:forEach>
            </div>
            <p class="text-muted small mb-0">Nhập mã ưu đãi ở bước đặt phòng để được áp dụng giảm giá.</p>
        </div>
    </div>
    </c:if>

    <div class="card">
        <div class="card-header"><i class="fas fa-receipt mr-2"></i>Lịch sử đặt phòng</div>
        <div class="card-body table-responsive">
            <table class="table table-bordered table-hover mb-0">
                <thead>
                <tr>
                    <th>Mã</th><th>Phòng</th><th>Ngày nhận</th><th>Ngày trả</th><th>Trạng thái</th><th>Tổng tiền</th><th>Giảm giá</th><th></th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="b" items="${bookings}">
                    <tr>
                        <td>#${b.id}</td>
                        <td>${b.roomNumber} - ${b.roomTypeName}</td>
                        <td>${b.checkInDate}</td>
                        <td>${b.checkOutDate}</td>
                        <td><span class="badge badge-status-${b.status}">${b.status}</span></td>
                        <td><fmt:formatNumber value="${b.totalAmount}" type="number" groupingUsed="true"/> VND</td>
                        <td>
                            <c:if test="${b.discountAmount > 0}">
                                -<fmt:formatNumber value="${b.discountAmount}" type="number" groupingUsed="true"/> VND
                                <span class="text-muted small">(${b.promoCode})</span>
                            </c:if>
                        </td>
                        <td><a href="${pageContext.request.contextPath}/account/bookings/${b.id}" class="btn btn-sm btn-outline-primary">Chi tiết</a></td>
                    </tr>
                </c:forEach>
                <c:if test="${empty bookings}">
                    <tr><td colspan="8" class="text-center text-muted">Bạn chưa có lượt đặt phòng nào.</td></tr>
                </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>

<%@ include file="../layout/public-footer.jsp" %>
