<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Top khách hàng" />
<%@ include file="../layout/header.jsp" %>

<div class="row mb-3 align-items-center">
    <div class="col-auto">
        <div class="btn-group">
            <a href="?limit=5"  class="btn btn-sm ${limit == 5  ? 'btn-primary' : 'btn-outline-primary'}">Top 5</a>
            <a href="?limit=10" class="btn btn-sm ${limit == 10 ? 'btn-primary' : 'btn-outline-primary'}">Top 10</a>
            <a href="?limit=20" class="btn btn-sm ${limit == 20 ? 'btn-primary' : 'btn-outline-primary'}">Top 20</a>
        </div>
    </div>
    <div class="col-auto ml-auto">
        <a href="${pageContext.request.contextPath}/admin/reports/top-customers/export?format=xlsx&limit=${limit}"
           class="btn btn-success btn-sm"><i class="fas fa-file-excel mr-1"></i>Excel</a>
        <a href="${pageContext.request.contextPath}/admin/reports/top-customers/export?format=pdf&limit=${limit}"
           class="btn btn-danger btn-sm ml-1"><i class="fas fa-file-pdf mr-1"></i>PDF</a>
    </div>
</div>

<%-- Summary cards --%>
<div class="row mb-4">
    <c:forEach var="tc" items="${topCustomers}" varStatus="st">
    <c:if test="${st.index < 3}">
    <div class="col-md-4 mb-3">
        <div class="card border-0 shadow-sm h-100">
            <div class="card-body d-flex align-items-center gap-3">
                <div style="font-size:2rem;font-weight:800;color:${st.index==0?'#f59e0b':st.index==1?'#94a3b8':'#b45309'};min-width:2.5rem;text-align:center;">
                    #${st.index + 1}
                </div>
                <div class="flex-grow-1">
                    <div style="font-weight:700;font-size:.95rem;">${tc.fullName}</div>
                    <div class="text-muted" style="font-size:.78rem;">${tc.phone}</div>
                    <div class="mt-1">
                        <span class="badge badge-pill" style="background:#ede9fe;color:#4f46e5;">${tc.bookingCount} lần đặt</span>
                        <span class="ml-1" style="font-weight:600;color:#4f46e5;font-size:.82rem;">
                            <fmt:formatNumber value="${tc.totalSpent}" type="number" groupingUsed="true" />đ
                        </span>
                    </div>
                </div>
            </div>
        </div>
    </div>
    </c:if>
    </c:forEach>
</div>

<%-- Chart --%>
<div class="card mb-4">
    <div class="card-header"><i class="fas fa-chart-bar text-brand"></i> Biểu đồ top ${limit} khách hàng (theo số lần đặt)</div>
    <div class="card-body">
        <div class="chart-wrapper-lg">
            <canvas id="topCustomersChart"></canvas>
        </div>
    </div>
</div>

<%-- Full table --%>
<div class="card">
    <div class="card-header"><i class="fas fa-trophy text-brand"></i> Danh sách top ${limit} khách hàng</div>
    <div class="card-body p-0">
        <div class="table-responsive">
            <table class="table table-hover mb-0">
                <thead>
                <tr>
                    <th style="width:48px;">#</th>
                    <th>Khách hàng</th>
                    <th>SĐT</th>
                    <th>Email</th>
                    <th class="text-center">Số lần đặt</th>
                    <th class="text-right">Tổng chi tiêu</th>
                    <th>Lần đặt gần nhất</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="tc" items="${topCustomers}" varStatus="st">
                    <tr>
                        <td>
                            <c:choose>
                                <c:when test="${st.index == 0}"><span style="color:#f59e0b;font-size:1.1rem;">🥇</span></c:when>
                                <c:when test="${st.index == 1}"><span style="color:#94a3b8;font-size:1.1rem;">🥈</span></c:when>
                                <c:when test="${st.index == 2}"><span style="color:#b45309;font-size:1.1rem;">🥉</span></c:when>
                                <c:otherwise><span class="text-muted font-weight-bold">${st.index + 1}</span></c:otherwise>
                            </c:choose>
                        </td>
                        <td style="font-weight:600;">${tc.fullName}</td>
                        <td>${tc.phone}</td>
                        <td class="text-muted" style="font-size:.85rem;">${empty tc.email ? '—' : tc.email}</td>
                        <td class="text-center">
                            <span class="badge badge-pill" style="background:#ede9fe;color:#4f46e5;font-size:.8rem;">${tc.bookingCount}</span>
                        </td>
                        <td class="text-right" style="font-weight:700;color:#4f46e5;">
                            <fmt:formatNumber value="${tc.totalSpent}" type="number" groupingUsed="true" />đ
                        </td>
                        <td class="text-muted" style="font-size:.85rem;">${tc.lastBookingDate}</td>
                    </tr>
                </c:forEach>
                <c:if test="${empty topCustomers}">
                    <tr><td colspan="7" class="text-center text-muted py-4">Chưa có dữ liệu.</td></tr>
                </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script>
(function () {
    var labels = [<c:forEach var="tc" items="${topCustomers}" varStatus="s">'${tc.fullName}'<c:if test="${!s.last}">,</c:if></c:forEach>];
    var bookings = [<c:forEach var="tc" items="${topCustomers}" varStatus="s">${tc.bookingCount}<c:if test="${!s.last}">,</c:if></c:forEach>];
    var spent = [<c:forEach var="tc" items="${topCustomers}" varStatus="s">${tc.totalSpent}<c:if test="${!s.last}">,</c:if></c:forEach>];
    var ctx = document.getElementById('topCustomersChart');
    if (!ctx || !labels.length) return;
    new Chart(ctx, {
        type: 'bar',
        data: {
            labels: labels,
            datasets: [{
                label: 'Số lần đặt phòng',
                data: bookings,
                backgroundColor: 'rgba(79,70,229,.2)',
                borderColor: '#4f46e5',
                borderWidth: 2,
                borderRadius: 6,
                yAxisID: 'y'
            }, {
                label: 'Tổng chi tiêu (VND)',
                data: spent,
                type: 'line',
                borderColor: '#10b981',
                backgroundColor: 'rgba(16,185,129,.1)',
                borderWidth: 2,
                pointBackgroundColor: '#10b981',
                pointRadius: 4,
                tension: .3,
                yAxisID: 'y1'
            }]
        },
        options: {
            responsive: true, maintainAspectRatio: false,
            plugins: { legend: { position: 'top', labels: { font: { weight: '600' } } } },
            scales: {
                y: {
                    type: 'linear', position: 'left',
                    grid: { color: '#f1f5f9' },
                    ticks: { stepSize: 1 }
                },
                y1: {
                    type: 'linear', position: 'right',
                    grid: { drawOnChartArea: false },
                    ticks: { callback: v => (v/1000000).toFixed(0)+'M' }
                },
                x: { grid: { display: false }, ticks: { maxRotation: 30 } }
            }
        }
    });
})();
</script>

<%@ include file="../layout/footer.jsp" %>
