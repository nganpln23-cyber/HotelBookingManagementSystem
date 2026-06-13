<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Dashboard" />
<%@ include file="../layout/header.jsp" %>
<div class="row">
    <div class="col-lg-3 col-6 mb-4">
        <div class="stat-card">
            <div class="stat-icon stat-icon-indigo"><i class="fas fa-door-open"></i></div>
            <div>
                <div class="stat-value">${stats.totalRooms}</div>
                <div class="stat-label">Tổng số phòng</div>
            </div>
        </div>
    </div>
    <div class="col-lg-3 col-6 mb-4">
        <div class="stat-card">
            <div class="stat-icon stat-icon-green"><i class="fas fa-check-circle"></i></div>
            <div>
                <div class="stat-value">${stats.availableRooms}</div>
                <div class="stat-label">Phòng trống</div>
            </div>
        </div>
    </div>
    <div class="col-lg-3 col-6 mb-4">
        <div class="stat-card">
            <div class="stat-icon stat-icon-amber"><i class="fas fa-users"></i></div>
            <div>
                <div class="stat-value">${stats.totalCustomers}</div>
                <div class="stat-label">Khách hàng</div>
            </div>
        </div>
    </div>
    <div class="col-lg-3 col-6 mb-4">
        <div class="stat-card">
            <div class="stat-icon stat-icon-cyan"><i class="fas fa-calendar-check"></i></div>
            <div>
                <div class="stat-value">${stats.totalBookings}</div>
                <div class="stat-label">Đơn đặt phòng</div>
            </div>
        </div>
    </div>
</div>
<div class="card">
    <div class="card-header"><i class="fas fa-coins mr-2"></i>Doanh thu dự kiến</div>
    <div class="card-body">
        <h2 class="font-weight-bold" style="color: var(--brand);"><fmt:formatNumber value="${stats.totalRevenue}" type="number" groupingUsed="true" /> VND</h2>
        <p class="text-muted mb-0">Tính theo booking có trạng thái CONFIRMED, CHECKED_IN, CHECKED_OUT.</p>
    </div>
</div>
<%@ include file="../layout/footer.jsp" %>
