<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Dashboard" />
<%@ include file="../layout/header.jsp" %>

<%-- Row 1: Occupancy stats --%>
<div class="row">
    <div class="col-xl col-md-4 col-6 mb-3">
        <div class="stat-card stat-indigo">
            <div class="stat-icon stat-icon-indigo"><i class="fas fa-door-open"></i></div>
            <div>
                <div class="stat-value">${stats.totalRooms}</div>
                <div class="stat-label">Tổng số phòng</div>
            </div>
        </div>
    </div>
    <div class="col-xl col-md-4 col-6 mb-3">
        <div class="stat-card stat-green">
            <div class="stat-icon stat-icon-green"><i class="fas fa-check-circle"></i></div>
            <div>
                <div class="stat-value">${stats.availableRooms}</div>
                <div class="stat-label">Phòng trống</div>
            </div>
        </div>
    </div>
    <div class="col-xl col-md-4 col-6 mb-3">
        <div class="stat-card stat-rose">
            <div class="stat-icon stat-icon-rose"><i class="fas fa-bed"></i></div>
            <div>
                <div class="stat-value">${stats.occupiedRooms}</div>
                <div class="stat-label">Đang có khách</div>
            </div>
        </div>
    </div>
    <div class="col-xl col-md-4 col-6 mb-3">
        <div class="stat-card stat-amber">
            <div class="stat-icon stat-icon-amber"><i class="fas fa-calendar-check"></i></div>
            <div>
                <div class="stat-value">${stats.bookedRooms}</div>
                <div class="stat-label">Đã được đặt</div>
            </div>
        </div>
    </div>
    <div class="col-xl col-md-4 col-6 mb-3">
        <div class="stat-card stat-violet" style="flex-direction:column;align-items:flex-start;gap:.3rem;">
            <div class="d-flex align-items-center gap-3 w-100">
                <div class="stat-icon stat-icon-violet"><i class="fas fa-percentage"></i></div>
                <div>
                    <div class="stat-value" style="font-size:1.5rem;">${stats.occupancyRate}%</div>
                    <div class="stat-label">Occupancy Rate</div>
                </div>
            </div>
            <div class="w-100 mt-1" style="background:#e0e7ff;border-radius:4px;height:5px;">
                <div style="background:#4f46e5;height:5px;border-radius:4px;width:${stats.occupancyRate}%;transition:width .5s;"></div>
            </div>
        </div>
    </div>
</div>

<%-- Row 2: Operational + Revenue stats --%>
<div class="row">
    <div class="col-xl-3 col-md-6 mb-3">
        <div class="stat-card stat-amber">
            <div class="stat-icon stat-icon-amber"><i class="fas fa-clock"></i></div>
            <div>
                <div class="stat-value">${stats.pendingBookings}</div>
                <div class="stat-label">Chờ xác nhận</div>
            </div>
        </div>
    </div>
    <div class="col-xl-3 col-md-6 mb-3">
        <div class="stat-card stat-cyan">
            <div class="stat-icon stat-icon-cyan"><i class="fas fa-key"></i></div>
            <div>
                <div class="stat-value">${stats.checkedInCount}</div>
                <div class="stat-label">Khách đang ở</div>
            </div>
        </div>
    </div>
    <div class="col-xl-4 col-md-6 mb-3">
        <div class="stat-card stat-violet" style="flex-direction:column;align-items:flex-start;gap:.5rem;">
            <div class="d-flex align-items-center gap-3 w-100">
                <div class="stat-icon stat-icon-violet"><i class="fas fa-coins"></i></div>
                <div>
                    <div class="stat-label">Doanh thu dự kiến</div>
                    <div class="stat-value" style="font-size:1.3rem;">
                        <fmt:formatNumber value="${stats.totalRevenue}" type="number" groupingUsed="true" /> VND
                    </div>
                </div>
            </div>
            <div class="text-muted" style="font-size:.72rem;">Tính từ CONFIRMED, CHECKED_IN, CHECKED_OUT</div>
        </div>
    </div>
    <div class="col-xl-4 col-md-6 mb-3">
        <div class="stat-card stat-rose">
            <div class="stat-icon stat-icon-rose"><i class="fas fa-users"></i></div>
            <div>
                <div class="stat-value">${stats.totalCustomers}</div>
                <div class="stat-label">Khách hàng</div>
            </div>
        </div>
    </div>
    <div class="col-xl-4 col-md-6 mb-3">
        <div class="stat-card stat-cyan">
            <div class="stat-icon stat-icon-cyan"><i class="fas fa-calendar-check"></i></div>
            <div>
                <div class="stat-value">${stats.totalBookings}</div>
                <div class="stat-label">Tổng đặt phòng</div>
            </div>
        </div>
    </div>
</div>

<%-- Row 3: Room status chart + Recent bookings --%>
<div class="row">
    <div class="col-xl-4 col-lg-5 mb-4">
        <div class="card h-100">
            <div class="card-header">
                <i class="fas fa-chart-pie" style="color:var(--brand);"></i>
                Tình trạng phòng
            </div>
            <div class="card-body d-flex flex-column align-items-center justify-content-center">
                <div class="chart-wrapper-sm w-100">
                    <canvas id="roomStatusChart"></canvas>
                </div>
                <div class="mt-3 w-100">
                    <div class="d-flex justify-content-between align-items-center py-1 border-bottom" style="font-size:.8rem;">
                        <span><span class="badge-dot" style="background:#22c55e;"></span> Trống</span>
                        <strong>${stats.availableRooms}</strong>
                    </div>
                    <div class="d-flex justify-content-between align-items-center py-1 border-bottom" style="font-size:.8rem;">
                        <span><span class="badge-dot" style="background:#f59e0b;"></span> Đã đặt</span>
                        <strong>${stats.bookedRooms}</strong>
                    </div>
                    <div class="d-flex justify-content-between align-items-center py-1 border-bottom" style="font-size:.8rem;">
                        <span><span class="badge-dot" style="background:#f43f5e;"></span> Đang ở</span>
                        <strong>${stats.occupiedRooms}</strong>
                    </div>
                    <div class="d-flex justify-content-between align-items-center py-1" style="font-size:.8rem;">
                        <span><span class="badge-dot" style="background:#94a3b8;"></span> Bảo trì</span>
                        <strong>${stats.maintenanceRooms}</strong>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="col-xl-8 col-lg-7 mb-4">
        <div class="card h-100">
            <div class="card-header d-flex justify-content-between align-items-center">
                <span><i class="fas fa-history" style="color:var(--brand);"></i> Đặt phòng gần đây</span>
                <a href="${pageContext.request.contextPath}/admin/bookings" class="btn btn-sm btn-outline-primary">Xem tất cả</a>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover mb-0">
                        <thead>
                        <tr>
                            <th>#</th>
                            <th>Khách</th>
                            <th>Phòng</th>
                            <th>Ngày vào</th>
                            <th>Ngày ra</th>
                            <th>Trạng thái</th>
                            <th>Tổng tiền</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="b" items="${stats.recentBookings}">
                            <tr>
                                <td class="text-muted">#${b.id}</td>
                                <td><strong>${b.customerName}</strong></td>
                                <td>${b.roomNumber}</td>
                                <td>${b.checkInDate}</td>
                                <td>${b.checkOutDate}</td>
                                <td><span class="badge badge-status-${b.status}">${b.status}</span></td>
                                <td><fmt:formatNumber value="${b.totalAmount}" type="number" groupingUsed="true" /> VND</td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty stats.recentBookings}">
                            <tr><td colspan="7" class="text-center text-muted py-4">Chưa có đặt phòng nào.</td></tr>
                        </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<style>
.badge-dot { display:inline-block; width:8px; height:8px; border-radius:50%; margin-right:.4rem; }
</style>

<script>
(function () {
    var ctx = document.getElementById('roomStatusChart');
    if (!ctx) return;
    new Chart(ctx, {
        type: 'doughnut',
        data: {
            labels: ['Trống', 'Đã đặt', 'Đang ở', 'Bảo trì'],
            datasets: [{
                data: [${stats.availableRooms}, ${stats.bookedRooms}, ${stats.occupiedRooms}, ${stats.maintenanceRooms}],
                backgroundColor: ['#22c55e', '#f59e0b', '#f43f5e', '#94a3b8'],
                borderWidth: 0,
                hoverOffset: 6
            }]
        },
        options: {
            cutout: '70%',
            plugins: {
                legend: { display: false },
                tooltip: { callbacks: { label: function(ctx) { return ' ' + ctx.label + ': ' + ctx.parsed + ' phòng'; } } }
            }
        }
    });
})();
</script>

<%@ include file="../layout/footer.jsp" %>
