<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Tỷ lệ lấp đầy phòng" />
<%@ include file="../layout/header.jsp" %>

<%-- Tab navigation --%>
<div class="report-tabs mb-0">
    <a href="?tab=monthly&year=${selectedYear}" class="report-tab ${tab == 'monthly' ? 'active' : ''}">
        <i class="fas fa-calendar-alt"></i> Theo tháng
    </a>
    <a href="?tab=quarterly&year=${selectedYear}" class="report-tab ${tab == 'quarterly' ? 'active' : ''}">
        <i class="fas fa-layer-group"></i> Theo quý
    </a>
    <a href="?tab=yearly" class="report-tab ${tab == 'yearly' ? 'active' : ''}">
        <i class="fas fa-chart-bar"></i> Theo năm
    </a>
</div>

<%-- Year selector (hidden for yearly tab) --%>
<c:if test="${tab != 'yearly'}">
<div class="card mb-0">
    <div class="card-body py-2">
        <form class="form-row align-items-end" method="get">
            <input type="hidden" name="tab" value="${tab}">
            <div class="form-group col-auto mb-0">
                <label class="mb-0 mr-2">Năm:</label>
                <select name="year" class="form-control form-control-sm" onchange="this.form.submit()">
                    <c:forEach begin="${currentYear - 4}" end="${currentYear}" var="y">
                        <option value="${y}" ${y == selectedYear ? 'selected' : ''}>${y}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="form-group col-auto mb-0 ml-auto">
                <a href="${pageContext.request.contextPath}/admin/reports/occupancy/export?format=xlsx&tab=${tab}&year=${selectedYear}"
                   class="btn btn-success btn-sm"><i class="fas fa-file-excel mr-1"></i>Excel</a>
                <a href="${pageContext.request.contextPath}/admin/reports/occupancy/export?format=pdf&tab=${tab}&year=${selectedYear}"
                   class="btn btn-danger btn-sm ml-1"><i class="fas fa-file-pdf mr-1"></i>PDF</a>
            </div>
        </form>
    </div>
</div>
</c:if>
<c:if test="${tab == 'yearly'}">
<div class="card mb-0">
    <div class="card-body py-2 d-flex justify-content-end">
        <a href="${pageContext.request.contextPath}/admin/reports/occupancy/export?format=xlsx&tab=yearly"
           class="btn btn-success btn-sm"><i class="fas fa-file-excel mr-1"></i>Excel</a>
        <a href="${pageContext.request.contextPath}/admin/reports/occupancy/export?format=pdf&tab=yearly"
           class="btn btn-danger btn-sm ml-1"><i class="fas fa-file-pdf mr-1"></i>PDF</a>
    </div>
</div>
</c:if>

<%-- ─── TAB: MONTHLY ────────────────────────────────────────────────────── --%>
<c:if test="${tab == 'monthly'}">
    <%-- Summary KPI --%>
    <c:set var="totalOccupied" value="0"/>
    <c:set var="totalAvail" value="0"/>
    <c:set var="totalBookings" value="0"/>
    <c:forEach var="d" items="${monthlyData}">
        <c:set var="totalOccupied" value="${totalOccupied + d.occupiedNights}"/>
        <c:set var="totalAvail" value="${totalAvail + d.availableNights}"/>
        <c:set var="totalBookings" value="${totalBookings + d.bookingCount}"/>
    </c:forEach>

    <div class="row mb-3 mt-3">
        <div class="col-md-4 mb-3">
            <div class="stat-card stat-indigo">
                <div class="stat-icon stat-icon-indigo"><i class="fas fa-bed"></i></div>
                <div>
                    <div class="stat-value">${monthlyData[0].totalRooms}</div>
                    <div class="stat-label">Tổng số phòng hoạt động</div>
                </div>
            </div>
        </div>
        <div class="col-md-4 mb-3">
            <div class="stat-card stat-green">
                <div class="stat-icon stat-icon-green"><i class="fas fa-moon"></i></div>
                <div>
                    <div class="stat-value">${totalOccupied}</div>
                    <div class="stat-label">Đêm phòng đã đặt (${selectedYear})</div>
                </div>
            </div>
        </div>
        <div class="col-md-4 mb-3">
            <div class="stat-card stat-yellow">
                <div class="stat-icon stat-icon-yellow"><i class="fas fa-percentage"></i></div>
                <div>
                    <div class="stat-value">
                        <c:choose>
                            <c:when test="${totalAvail > 0}">
                                <fmt:formatNumber value="${totalOccupied * 100.0 / totalAvail}" maxFractionDigits="1"/>%
                            </c:when>
                            <c:otherwise>0%</c:otherwise>
                        </c:choose>
                    </div>
                    <div class="stat-label">Tỷ lệ lấp đầy trung bình</div>
                </div>
            </div>
        </div>
    </div>

    <div class="card mb-4">
        <div class="card-header"><i class="fas fa-chart-bar text-brand"></i> Tỷ lệ lấp đầy theo tháng — ${selectedYear}</div>
        <div class="card-body">
            <div class="chart-wrapper-lg">
                <canvas id="monthlyChart"></canvas>
            </div>
        </div>
    </div>

    <div class="card">
        <div class="card-header"><i class="fas fa-table text-brand"></i> Chi tiết theo tháng</div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover mb-0">
                    <thead>
                        <tr>
                            <th>Tháng</th>
                            <th class="text-center">Tổng phòng</th>
                            <th class="text-center">Đêm có sẵn</th>
                            <th class="text-center">Đêm đã đặt</th>
                            <th class="text-center">Số booking</th>
                            <th class="text-center">Tỷ lệ lấp đầy</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="d" items="${monthlyData}">
                        <tr>
                            <td><strong>${d.label}</strong></td>
                            <td class="text-center">${d.totalRooms}</td>
                            <td class="text-center">${d.availableNights}</td>
                            <td class="text-center">${d.occupiedNights}</td>
                            <td class="text-center">${d.bookingCount}</td>
                            <td class="text-center">
                                <div class="d-flex align-items-center justify-content-center">
                                    <div style="width:80px;background:#e2e8f0;border-radius:4px;height:8px;margin-right:8px;">
                                        <div style="width:${d.occupancyRate}%;background:${d.occupancyRate >= 70 ? '#10b981' : d.occupancyRate >= 40 ? '#f59e0b' : '#ef4444'};border-radius:4px;height:8px;max-width:100%;"></div>
                                    </div>
                                    <span class="font-weight-bold" style="color:${d.occupancyRate >= 70 ? '#10b981' : d.occupancyRate >= 40 ? '#f59e0b' : '#ef4444'}">
                                        <fmt:formatNumber value="${d.occupancyRate}" maxFractionDigits="1"/>%
                                    </span>
                                </div>
                            </td>
                        </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <script>
    (function() {
        const labels = [<c:forEach var="d" items="${monthlyData}" varStatus="s">'${d.label}'<c:if test="${!s.last}">,</c:if></c:forEach>];
        const rates  = [<c:forEach var="d" items="${monthlyData}" varStatus="s"><fmt:formatNumber value="${d.occupancyRate}" maxFractionDigits="1" groupingUsed="false"/><c:if test="${!s.last}">,</c:if></c:forEach>];
        const nights = [<c:forEach var="d" items="${monthlyData}" varStatus="s">${d.occupiedNights}<c:if test="${!s.last}">,</c:if></c:forEach>];

        new Chart(document.getElementById('monthlyChart'), {
            type: 'bar',
            data: {
                labels,
                datasets: [
                    {
                        label: 'Tỷ lệ lấp đầy (%)',
                        data: rates,
                        backgroundColor: rates.map(r => r >= 70 ? 'rgba(16,185,129,0.75)' : r >= 40 ? 'rgba(245,158,11,0.75)' : 'rgba(239,68,68,0.75)'),
                        borderRadius: 4,
                        yAxisID: 'yRate'
                    },
                    {
                        label: 'Đêm đã đặt',
                        data: nights,
                        type: 'line',
                        borderColor: '#6366f1',
                        backgroundColor: 'rgba(99,102,241,0.1)',
                        borderWidth: 2,
                        tension: 0.3,
                        pointRadius: 4,
                        fill: true,
                        yAxisID: 'yNights'
                    }
                ]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: { legend: { position: 'top' } },
                scales: {
                    yRate: { type: 'linear', position: 'left', min: 0, max: 100,
                        title: { display: true, text: 'Tỷ lệ (%)' } },
                    yNights: { type: 'linear', position: 'right', beginAtZero: true,
                        grid: { drawOnChartArea: false },
                        title: { display: true, text: 'Đêm đặt' } }
                }
            }
        });
    })();
    </script>
</c:if>

<%-- ─── TAB: QUARTERLY ─────────────────────────────────────────────────── --%>
<c:if test="${tab == 'quarterly'}">
    <c:set var="totalOccupied" value="0"/>
    <c:set var="totalAvail" value="0"/>
    <c:set var="totalBookings" value="0"/>
    <c:forEach var="d" items="${quarterlyData}">
        <c:set var="totalOccupied" value="${totalOccupied + d.occupiedNights}"/>
        <c:set var="totalAvail" value="${totalAvail + d.availableNights}"/>
        <c:set var="totalBookings" value="${totalBookings + d.bookingCount}"/>
    </c:forEach>

    <div class="row mb-3 mt-3">
        <div class="col-md-4 mb-3">
            <div class="stat-card stat-indigo">
                <div class="stat-icon stat-icon-indigo"><i class="fas fa-bed"></i></div>
                <div>
                    <c:if test="${not empty quarterlyData}">
                    <div class="stat-value">${quarterlyData[0].totalRooms}</div>
                    </c:if>
                    <div class="stat-label">Tổng số phòng hoạt động</div>
                </div>
            </div>
        </div>
        <div class="col-md-4 mb-3">
            <div class="stat-card stat-green">
                <div class="stat-icon stat-icon-green"><i class="fas fa-moon"></i></div>
                <div>
                    <div class="stat-value">${totalOccupied}</div>
                    <div class="stat-label">Đêm phòng đã đặt (${selectedYear})</div>
                </div>
            </div>
        </div>
        <div class="col-md-4 mb-3">
            <div class="stat-card stat-yellow">
                <div class="stat-icon stat-icon-yellow"><i class="fas fa-percentage"></i></div>
                <div>
                    <div class="stat-value">
                        <c:choose>
                            <c:when test="${totalAvail > 0}">
                                <fmt:formatNumber value="${totalOccupied * 100.0 / totalAvail}" maxFractionDigits="1"/>%
                            </c:when>
                            <c:otherwise>0%</c:otherwise>
                        </c:choose>
                    </div>
                    <div class="stat-label">Tỷ lệ lấp đầy trung bình</div>
                </div>
            </div>
        </div>
    </div>

    <div class="card mb-4">
        <div class="card-header"><i class="fas fa-chart-bar text-brand"></i> Tỷ lệ lấp đầy theo quý — ${selectedYear}</div>
        <div class="card-body">
            <div class="chart-wrapper-lg">
                <canvas id="quarterlyChart"></canvas>
            </div>
        </div>
    </div>

    <div class="card">
        <div class="card-header"><i class="fas fa-table text-brand"></i> Chi tiết theo quý</div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover mb-0">
                    <thead>
                        <tr>
                            <th>Quý</th>
                            <th class="text-center">Tổng phòng</th>
                            <th class="text-center">Đêm có sẵn</th>
                            <th class="text-center">Đêm đã đặt</th>
                            <th class="text-center">Số booking</th>
                            <th class="text-center">Tỷ lệ lấp đầy</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="d" items="${quarterlyData}">
                        <tr>
                            <td><strong>${d.label}</strong></td>
                            <td class="text-center">${d.totalRooms}</td>
                            <td class="text-center">${d.availableNights}</td>
                            <td class="text-center">${d.occupiedNights}</td>
                            <td class="text-center">${d.bookingCount}</td>
                            <td class="text-center">
                                <div class="d-flex align-items-center justify-content-center">
                                    <div style="width:80px;background:#e2e8f0;border-radius:4px;height:8px;margin-right:8px;">
                                        <div style="width:${d.occupancyRate}%;background:${d.occupancyRate >= 70 ? '#10b981' : d.occupancyRate >= 40 ? '#f59e0b' : '#ef4444'};border-radius:4px;height:8px;max-width:100%;"></div>
                                    </div>
                                    <span class="font-weight-bold" style="color:${d.occupancyRate >= 70 ? '#10b981' : d.occupancyRate >= 40 ? '#f59e0b' : '#ef4444'}">
                                        <fmt:formatNumber value="${d.occupancyRate}" maxFractionDigits="1"/>%
                                    </span>
                                </div>
                            </td>
                        </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <script>
    (function() {
        const labels = [<c:forEach var="d" items="${quarterlyData}" varStatus="s">'${d.label}'<c:if test="${!s.last}">,</c:if></c:forEach>];
        const rates  = [<c:forEach var="d" items="${quarterlyData}" varStatus="s"><fmt:formatNumber value="${d.occupancyRate}" maxFractionDigits="1" groupingUsed="false"/><c:if test="${!s.last}">,</c:if></c:forEach>];
        const nights = [<c:forEach var="d" items="${quarterlyData}" varStatus="s">${d.occupiedNights}<c:if test="${!s.last}">,</c:if></c:forEach>];

        new Chart(document.getElementById('quarterlyChart'), {
            type: 'bar',
            data: {
                labels,
                datasets: [
                    {
                        label: 'Tỷ lệ lấp đầy (%)',
                        data: rates,
                        backgroundColor: rates.map(r => r >= 70 ? 'rgba(16,185,129,0.75)' : r >= 40 ? 'rgba(245,158,11,0.75)' : 'rgba(239,68,68,0.75)'),
                        borderRadius: 6,
                        yAxisID: 'yRate'
                    },
                    {
                        label: 'Đêm đã đặt',
                        data: nights,
                        type: 'line',
                        borderColor: '#6366f1',
                        backgroundColor: 'rgba(99,102,241,0.1)',
                        borderWidth: 2,
                        tension: 0.3,
                        pointRadius: 5,
                        fill: true,
                        yAxisID: 'yNights'
                    }
                ]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: { legend: { position: 'top' } },
                scales: {
                    yRate: { type: 'linear', position: 'left', min: 0, max: 100,
                        title: { display: true, text: 'Tỷ lệ (%)' } },
                    yNights: { type: 'linear', position: 'right', beginAtZero: true,
                        grid: { drawOnChartArea: false },
                        title: { display: true, text: 'Đêm đặt' } }
                }
            }
        });
    })();
    </script>
</c:if>

<%-- ─── TAB: YEARLY ────────────────────────────────────────────────────── --%>
<c:if test="${tab == 'yearly'}">
    <div class="card mb-4 mt-3">
        <div class="card-header"><i class="fas fa-chart-bar text-brand"></i> Tỷ lệ lấp đầy theo năm</div>
        <div class="card-body">
            <div class="chart-wrapper-lg">
                <canvas id="yearlyChart"></canvas>
            </div>
        </div>
    </div>

    <div class="card">
        <div class="card-header"><i class="fas fa-table text-brand"></i> Chi tiết theo năm</div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover mb-0">
                    <thead>
                        <tr>
                            <th>Năm</th>
                            <th class="text-center">Tổng phòng</th>
                            <th class="text-center">Đêm có sẵn</th>
                            <th class="text-center">Đêm đã đặt</th>
                            <th class="text-center">Số booking</th>
                            <th class="text-center">Tỷ lệ lấp đầy</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="d" items="${yearlyData}">
                        <tr>
                            <td><strong>${d.label}</strong></td>
                            <td class="text-center">${d.totalRooms}</td>
                            <td class="text-center">${d.availableNights}</td>
                            <td class="text-center">${d.occupiedNights}</td>
                            <td class="text-center">${d.bookingCount}</td>
                            <td class="text-center">
                                <div class="d-flex align-items-center justify-content-center">
                                    <div style="width:80px;background:#e2e8f0;border-radius:4px;height:8px;margin-right:8px;">
                                        <div style="width:${d.occupancyRate}%;background:${d.occupancyRate >= 70 ? '#10b981' : d.occupancyRate >= 40 ? '#f59e0b' : '#ef4444'};border-radius:4px;height:8px;max-width:100%;"></div>
                                    </div>
                                    <span class="font-weight-bold" style="color:${d.occupancyRate >= 70 ? '#10b981' : d.occupancyRate >= 40 ? '#f59e0b' : '#ef4444'}">
                                        <fmt:formatNumber value="${d.occupancyRate}" maxFractionDigits="1"/>%
                                    </span>
                                </div>
                            </td>
                        </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <script>
    (function() {
        const labels = [<c:forEach var="d" items="${yearlyData}" varStatus="s">'${d.label}'<c:if test="${!s.last}">,</c:if></c:forEach>];
        const rates  = [<c:forEach var="d" items="${yearlyData}" varStatus="s"><fmt:formatNumber value="${d.occupancyRate}" maxFractionDigits="1" groupingUsed="false"/><c:if test="${!s.last}">,</c:if></c:forEach>];

        new Chart(document.getElementById('yearlyChart'), {
            type: 'bar',
            data: {
                labels,
                datasets: [{
                    label: 'Tỷ lệ lấp đầy (%)',
                    data: rates,
                    backgroundColor: rates.map(r => r >= 70 ? 'rgba(16,185,129,0.75)' : r >= 40 ? 'rgba(245,158,11,0.75)' : 'rgba(239,68,68,0.75)'),
                    borderRadius: 6
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: { legend: { position: 'top' } },
                scales: {
                    y: { min: 0, max: 100, title: { display: true, text: 'Tỷ lệ (%)' } }
                }
            }
        });
    })();
    </script>
</c:if>

<%@ include file="../layout/footer.jsp" %>
