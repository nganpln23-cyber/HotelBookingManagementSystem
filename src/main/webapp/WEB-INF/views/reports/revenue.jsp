<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Báo cáo doanh thu" />
<%@ include file="../layout/header.jsp" %>

<%-- Tab navigation --%>
<div class="report-tabs mb-0">
    <a href="?tab=daily&from=${report.from}&to=${report.to}" class="report-tab ${tab == 'daily' ? 'active' : ''}">
        <i class="fas fa-calendar-day"></i> Theo ngày
    </a>
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

<%-- ─── TAB: DAILY ─────────────────────────────── --%>
<c:if test="${tab == 'daily'}">
    <div class="card">
        <div class="card-body">
            <form class="form-row align-items-end" method="get" action="${pageContext.request.contextPath}/admin/reports/revenue">
                <input type="hidden" name="tab" value="daily">
                <div class="form-group col-auto mb-0">
                    <label>Từ ngày</label>
                    <input type="text" id="reportFrom" name="from" class="form-control form-control-sm" value="${report.from}" placeholder="Chọn ngày" autocomplete="off">
                </div>
                <div class="form-group col-auto mb-0">
                    <label>Đến ngày</label>
                    <input type="text" id="reportTo" name="to" class="form-control form-control-sm" value="${report.to}" placeholder="Chọn ngày" autocomplete="off">
                </div>
                <div class="form-group col-auto mb-0">
                    <button type="submit" class="btn btn-primary btn-sm"><i class="fas fa-filter mr-1"></i>Lọc</button>
                </div>
            </form>
        </div>
    </div>

    <div class="row mb-3">
        <div class="col-md-6 mb-3">
            <div class="stat-card stat-green">
                <div class="stat-icon stat-icon-green"><i class="fas fa-coins"></i></div>
                <div>
                    <div class="stat-value" style="font-size:1.3rem;">
                        <fmt:formatNumber value="${report.totalRevenue}" type="number" groupingUsed="true" />đ
                    </div>
                    <div class="stat-label">Tổng doanh thu</div>
                </div>
            </div>
        </div>
        <div class="col-md-6 mb-3">
            <div class="stat-card stat-indigo">
                <div class="stat-icon stat-icon-indigo"><i class="fas fa-receipt"></i></div>
                <div>
                    <div class="stat-value">${report.paymentCount}</div>
                    <div class="stat-label">Giao dịch</div>
                </div>
            </div>
        </div>
    </div>

    <div class="card mb-4">
        <div class="card-header"><i class="fas fa-chart-line text-brand"></i> Biểu đồ doanh thu theo ngày</div>
        <div class="card-body">
            <div class="chart-wrapper-lg">
                <canvas id="dailyChart"></canvas>
            </div>
        </div>
    </div>

    <div class="row">
        <div class="col-md-7 mb-4">
            <div class="card h-100">
                <div class="card-header"><i class="fas fa-calendar-day text-brand"></i> Chi tiết theo ngày</div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover mb-0">
                            <thead><tr><th>Ngày</th><th>Giao dịch</th><th class="text-right">Doanh thu</th></tr></thead>
                            <tbody>
                            <c:forEach var="d" items="${report.dailyRevenue}">
                                <tr>
                                    <td style="font-weight:600;">${d.date}</td>
                                    <td>${d.paymentCount}</td>
                                    <td class="text-right" style="font-weight:600;color:#4f46e5;">
                                        <fmt:formatNumber value="${d.totalAmount}" type="number" groupingUsed="true" />đ
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty report.dailyRevenue}">
                                <tr><td colspan="3" class="text-center text-muted py-4">Không có dữ liệu trong khoảng thời gian này.</td></tr>
                            </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-5 mb-4">
            <div class="card h-100">
                <div class="card-header"><i class="fas fa-bed text-brand"></i> Theo loại phòng</div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover mb-0">
                            <thead><tr><th>Loại phòng</th><th>Booking</th><th class="text-right">Doanh thu</th></tr></thead>
                            <tbody>
                            <c:forEach var="r" items="${report.roomTypeRevenue}">
                                <tr>
                                    <td style="font-weight:600;">${r.typeName}</td>
                                    <td>${r.bookingCount}</td>
                                    <td class="text-right" style="font-weight:600;color:#4f46e5;">
                                        <fmt:formatNumber value="${r.totalAmount}" type="number" groupingUsed="true" />đ
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty report.roomTypeRevenue}">
                                <tr><td colspan="3" class="text-center text-muted py-4">Không có dữ liệu.</td></tr>
                            </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
    flatpickr("#reportFrom", { locale: "vn", dateFormat: "Y-m-d", altInput: true, altFormat: "d/m/Y" });
    flatpickr("#reportTo",   { locale: "vn", dateFormat: "Y-m-d", altInput: true, altFormat: "d/m/Y" });

    (function () {
        var labels = [<c:forEach var="d" items="${report.dailyRevenue}" varStatus="s">'${d.date}'<c:if test="${!s.last}">,</c:if></c:forEach>];
        var data   = [<c:forEach var="d" items="${report.dailyRevenue}" varStatus="s">${d.totalAmount}<c:if test="${!s.last}">,</c:if></c:forEach>];
        var ctx = document.getElementById('dailyChart');
        if (!ctx || !labels.length) return;
        new Chart(ctx, {
            type: 'bar',
            data: {
                labels: labels,
                datasets: [{
                    label: 'Doanh thu (VND)',
                    data: data,
                    backgroundColor: 'rgba(79,70,229,.15)',
                    borderColor: '#4f46e5',
                    borderWidth: 2,
                    borderRadius: 6,
                    hoverBackgroundColor: 'rgba(79,70,229,.3)'
                }]
            },
            options: {
                responsive: true, maintainAspectRatio: false,
                plugins: { legend: { display: false } },
                scales: {
                    y: { grid: { color: '#f1f5f9' }, ticks: { callback: v => (v/1000000).toFixed(1)+'M' } },
                    x: { grid: { display: false } }
                }
            }
        });
    })();
    </script>
</c:if>

<%-- ─── TAB: MONTHLY ───────────────────────────── --%>
<c:if test="${tab == 'monthly'}">
    <div class="card">
        <div class="card-body">
            <form class="form-row align-items-end" method="get" action="${pageContext.request.contextPath}/admin/reports/revenue">
                <input type="hidden" name="tab" value="monthly">
                <div class="form-group col-auto mb-0">
                    <label>Năm</label>
                    <select name="year" class="form-control form-control-sm" onchange="this.form.submit()">
                        <c:forEach begin="${currentYear - 4}" end="${currentYear}" var="y">
                            <option value="${y}" ${y == selectedYear ? 'selected' : ''}>${y}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="form-group col-auto mb-0">
                    <button type="submit" class="btn btn-primary btn-sm"><i class="fas fa-filter mr-1"></i>Lọc</button>
                </div>
            </form>
        </div>
    </div>

    <div class="card mb-4">
        <div class="card-header">
            <i class="fas fa-chart-bar text-brand"></i>
            Doanh thu năm ${selectedYear} theo tháng
        </div>
        <div class="card-body">
            <div class="chart-wrapper-lg">
                <canvas id="monthlyChart"></canvas>
            </div>
        </div>
    </div>

    <div class="card">
        <div class="card-header"><i class="fas fa-table text-brand"></i> Bảng doanh thu tháng</div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover mb-0">
                    <thead>
                    <tr>
                        <th>Tháng</th>
                        <th>Giao dịch</th>
                        <th class="text-right">Doanh thu</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:set var="monthNames" value="Tháng 1,Tháng 2,Tháng 3,Tháng 4,Tháng 5,Tháng 6,Tháng 7,Tháng 8,Tháng 9,Tháng 10,Tháng 11,Tháng 12" />
                    <c:forEach var="m" items="${monthlyData}">
                        <tr>
                            <td style="font-weight:600;">Tháng ${m.month} / ${m.year}</td>
                            <td>${m.paymentCount}</td>
                            <td class="text-right" style="font-weight:600;color:#4f46e5;">
                                <fmt:formatNumber value="${m.totalAmount}" type="number" groupingUsed="true" />đ
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty monthlyData}">
                        <tr><td colspan="3" class="text-center text-muted py-4">Không có dữ liệu năm ${selectedYear}.</td></tr>
                    </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <script>
    (function () {
        var labels = ['T1','T2','T3','T4','T5','T6','T7','T8','T9','T10','T11','T12'];
        var data = new Array(12).fill(0);
        var counts = new Array(12).fill(0);
        <c:forEach var="m" items="${monthlyData}">
        data[${m.month}-1] = ${m.totalAmount};
        counts[${m.month}-1] = ${m.paymentCount};
        </c:forEach>
        var ctx = document.getElementById('monthlyChart');
        if (!ctx) return;
        new Chart(ctx, {
            type: 'bar',
            data: {
                labels: labels,
                datasets: [{
                    label: 'Doanh thu (VND)',
                    data: data,
                    backgroundColor: 'rgba(79,70,229,.2)',
                    borderColor: '#4f46e5',
                    borderWidth: 2,
                    borderRadius: 8,
                    yAxisID: 'y'
                }, {
                    label: 'Giao dịch',
                    data: counts,
                    type: 'line',
                    borderColor: '#10b981',
                    backgroundColor: 'rgba(16,185,129,.1)',
                    borderWidth: 2,
                    pointBackgroundColor: '#10b981',
                    pointRadius: 4,
                    tension: .4,
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
                        ticks: { callback: v => (v/1000000).toFixed(0)+'M' }
                    },
                    y1: {
                        type: 'linear', position: 'right',
                        grid: { drawOnChartArea: false },
                        ticks: { stepSize: 1 }
                    },
                    x: { grid: { display: false } }
                }
            }
        });
    })();
    </script>
</c:if>

<%-- ─── TAB: YEARLY ────────────────────────────── --%>
<c:if test="${tab == 'yearly'}">
    <div class="card mb-4">
        <div class="card-header">
            <i class="fas fa-chart-bar text-brand"></i> Doanh thu theo năm (tổng hợp)
        </div>
        <div class="card-body">
            <div class="chart-wrapper-lg">
                <canvas id="yearlyChart"></canvas>
            </div>
        </div>
    </div>

    <div class="card">
        <div class="card-header"><i class="fas fa-table text-brand"></i> Bảng doanh thu năm</div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover mb-0">
                    <thead>
                    <tr>
                        <th>Năm</th>
                        <th>Giao dịch</th>
                        <th class="text-right">Doanh thu</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="y" items="${yearlyData}">
                        <tr>
                            <td style="font-weight:700;font-size:1rem;">${y.year}</td>
                            <td>${y.paymentCount}</td>
                            <td class="text-right" style="font-weight:700;color:#4f46e5;font-size:1rem;">
                                <fmt:formatNumber value="${y.totalAmount}" type="number" groupingUsed="true" />đ
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty yearlyData}">
                        <tr><td colspan="3" class="text-center text-muted py-4">Chưa có dữ liệu thanh toán nào.</td></tr>
                    </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <script>
    (function () {
        var labels = [<c:forEach var="y" items="${yearlyData}" varStatus="s">'${y.year}'<c:if test="${!s.last}">,</c:if></c:forEach>];
        var data   = [<c:forEach var="y" items="${yearlyData}" varStatus="s">${y.totalAmount}<c:if test="${!s.last}">,</c:if></c:forEach>];
        var ctx = document.getElementById('yearlyChart');
        if (!ctx || !labels.length) return;
        new Chart(ctx, {
            type: 'bar',
            data: {
                labels: labels,
                datasets: [{
                    label: 'Doanh thu (VND)',
                    data: data,
                    backgroundColor: [
                        'rgba(79,70,229,.25)','rgba(16,185,129,.25)','rgba(245,158,11,.25)',
                        'rgba(6,182,212,.25)','rgba(239,68,68,.25)'
                    ],
                    borderColor: [
                        '#4f46e5','#10b981','#f59e0b','#06b6d4','#ef4444'
                    ],
                    borderWidth: 2,
                    borderRadius: 10
                }]
            },
            options: {
                responsive: true, maintainAspectRatio: false,
                plugins: { legend: { display: false } },
                scales: {
                    y: { grid: { color: '#f1f5f9' }, ticks: { callback: v => (v/1000000).toFixed(0)+'M' } },
                    x: { grid: { display: false } }
                }
            }
        });
    })();
    </script>
</c:if>

<%-- ─── TAB: QUARTERLY ──────────────────────────── --%>
<c:if test="${tab == 'quarterly'}">
    <div class="card">
        <div class="card-body">
            <form class="form-row align-items-end" method="get" action="${pageContext.request.contextPath}/admin/reports/revenue">
                <input type="hidden" name="tab" value="quarterly">
                <div class="form-group col-auto mb-0">
                    <label>Năm</label>
                    <select name="year" class="form-control form-control-sm" onchange="this.form.submit()">
                        <c:forEach begin="${currentYear - 4}" end="${currentYear}" var="y">
                            <option value="${y}" ${y == selectedYear ? 'selected' : ''}>${y}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="form-group col-auto mb-0">
                    <button type="submit" class="btn btn-primary btn-sm"><i class="fas fa-filter mr-1"></i>Lọc</button>
                </div>
            </form>
        </div>
    </div>

    <div class="row mb-3">
        <c:forEach var="q" items="${quarterlyData}">
        <div class="col-md-3 mb-3">
            <div class="stat-card stat-indigo" style="flex-direction:column;align-items:flex-start;gap:.4rem;">
                <div class="stat-label" style="font-size:.75rem;text-transform:uppercase;letter-spacing:.06em;">
                    <i class="fas fa-layer-group mr-1"></i>Quý ${q.quarter} / ${q.year}
                </div>
                <div class="stat-value" style="font-size:1.2rem;">
                    <fmt:formatNumber value="${q.totalAmount}" type="number" groupingUsed="true" />đ
                </div>
                <div class="text-muted" style="font-size:.72rem;">${q.paymentCount} giao dịch</div>
            </div>
        </div>
        </c:forEach>
        <c:if test="${empty quarterlyData}">
        <div class="col-12">
            <div class="alert alert-info"><i class="fas fa-info-circle mr-1"></i>Không có dữ liệu quý nào trong năm ${selectedYear}.</div>
        </div>
        </c:if>
    </div>

    <div class="card mb-4">
        <div class="card-header">
            <i class="fas fa-chart-bar text-brand"></i> Biểu đồ doanh thu theo quý — Năm ${selectedYear}
        </div>
        <div class="card-body">
            <div class="chart-wrapper-lg">
                <canvas id="quarterlyChart"></canvas>
            </div>
        </div>
    </div>

    <div class="card">
        <div class="card-header"><i class="fas fa-table text-brand"></i> Bảng doanh thu theo quý</div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover mb-0">
                    <thead>
                    <tr>
                        <th>Quý</th>
                        <th>Giao dịch</th>
                        <th class="text-right">Doanh thu</th>
                        <th class="text-right">Tỷ lệ</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:set var="qTotal" value="0" />
                    <c:forEach var="q" items="${quarterlyData}">
                        <c:set var="qTotal" value="${qTotal + q.totalAmount}" />
                    </c:forEach>
                    <c:forEach var="q" items="${quarterlyData}">
                        <tr>
                            <td style="font-weight:700;">Q${q.quarter} / ${q.year}</td>
                            <td>${q.paymentCount}</td>
                            <td class="text-right" style="font-weight:700;color:#4f46e5;">
                                <fmt:formatNumber value="${q.totalAmount}" type="number" groupingUsed="true" />đ
                            </td>
                            <td class="text-right">
                                <c:if test="${qTotal > 0}">
                                    <fmt:formatNumber value="${q.totalAmount / qTotal * 100}" maxFractionDigits="1" />%
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty quarterlyData}">
                        <tr><td colspan="4" class="text-center text-muted py-4">Không có dữ liệu năm ${selectedYear}.</td></tr>
                    </c:if>
                    </tbody>
                    <c:if test="${not empty quarterlyData}">
                    <tfoot class="font-weight-bold bg-light">
                        <tr>
                            <td>Tổng cộng</td>
                            <td><c:forEach var="q" items="${quarterlyData}"><c:set var="totalTx" value="${totalTx + q.paymentCount}"/></c:forEach>${totalTx}</td>
                            <td class="text-right" style="color:#4f46e5;"><fmt:formatNumber value="${qTotal}" type="number" groupingUsed="true" />đ</td>
                            <td class="text-right">100%</td>
                        </tr>
                    </tfoot>
                    </c:if>
                </table>
            </div>
        </div>
    </div>

    <script>
    (function () {
        var labels = ['Q1','Q2','Q3','Q4'];
        var data = new Array(4).fill(0);
        var counts = new Array(4).fill(0);
        <c:forEach var="q" items="${quarterlyData}">
        data[${q.quarter}-1] = ${q.totalAmount};
        counts[${q.quarter}-1] = ${q.paymentCount};
        </c:forEach>
        var ctx = document.getElementById('quarterlyChart');
        if (!ctx) return;
        new Chart(ctx, {
            type: 'bar',
            data: {
                labels: labels,
                datasets: [{
                    label: 'Doanh thu (VND)',
                    data: data,
                    backgroundColor: ['rgba(79,70,229,.25)','rgba(16,185,129,.25)','rgba(245,158,11,.25)','rgba(6,182,212,.25)'],
                    borderColor: ['#4f46e5','#10b981','#f59e0b','#06b6d4'],
                    borderWidth: 2,
                    borderRadius: 10,
                    yAxisID: 'y'
                }, {
                    label: 'Giao dịch',
                    data: counts,
                    type: 'line',
                    borderColor: '#f43f5e',
                    backgroundColor: 'rgba(244,63,94,.1)',
                    borderWidth: 2,
                    pointBackgroundColor: '#f43f5e',
                    pointRadius: 5,
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
                        ticks: { callback: v => (v/1000000).toFixed(0)+'M' }
                    },
                    y1: {
                        type: 'linear', position: 'right',
                        grid: { drawOnChartArea: false },
                        ticks: { stepSize: 1 }
                    },
                    x: { grid: { display: false } }
                }
            }
        });
    })();
    </script>
</c:if>

<%@ include file="../layout/footer.jsp" %>
