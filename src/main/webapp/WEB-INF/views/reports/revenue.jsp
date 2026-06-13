<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Báo cáo doanh thu" />
<%@ include file="../layout/header.jsp" %>

<div class="card">
    <div class="card-body">
        <form class="form-row align-items-end" method="get" action="${pageContext.request.contextPath}/admin/reports/revenue">
            <div class="form-group col-auto">
                <label>Từ ngày</label>
                <input type="text" id="reportFrom" name="from" class="form-control" value="${report.from}" placeholder="Chọn ngày" autocomplete="off">
            </div>
            <div class="form-group col-auto">
                <label>Đến ngày</label>
                <input type="text" id="reportTo" name="to" class="form-control" value="${report.to}" placeholder="Chọn ngày" autocomplete="off">
            </div>
            <div class="form-group col-auto">
                <button type="submit" class="btn btn-primary"><i class="fas fa-filter mr-1"></i>Lọc</button>
            </div>
        </form>
    </div>
</div>

<script>
    flatpickr("#reportFrom", { locale: "vn", dateFormat: "Y-m-d", altInput: true, altFormat: "d/m/Y" });
    flatpickr("#reportTo", { locale: "vn", dateFormat: "Y-m-d", altInput: true, altFormat: "d/m/Y" });
</script>

<div class="row">
    <div class="col-md-6 mb-4">
        <div class="stat-card">
            <div class="stat-icon stat-icon-green"><i class="fas fa-coins"></i></div>
            <div>
                <div class="stat-value"><fmt:formatNumber value="${report.totalRevenue}" type="number" groupingUsed="true" /> VND</div>
                <div class="stat-label">Tổng doanh thu</div>
            </div>
        </div>
    </div>
    <div class="col-md-6 mb-4">
        <div class="stat-card">
            <div class="stat-icon stat-icon-indigo"><i class="fas fa-receipt"></i></div>
            <div>
                <div class="stat-value">${report.paymentCount}</div>
                <div class="stat-label">Số giao dịch thanh toán</div>
            </div>
        </div>
    </div>
</div>

<div class="row">
    <div class="col-md-6">
        <div class="card">
            <div class="card-header"><i class="fas fa-calendar-day mr-2"></i>Doanh thu theo ngày</div>
            <div class="card-body table-responsive">
                <table class="table table-bordered table-hover">
                    <thead><tr><th>Ngày</th><th>Số giao dịch</th><th>Doanh thu</th></tr></thead>
                    <tbody>
                    <c:forEach var="d" items="${report.dailyRevenue}">
                        <tr>
                            <td>${d.date}</td>
                            <td>${d.paymentCount}</td>
                            <td><fmt:formatNumber value="${d.totalAmount}" type="number" groupingUsed="true" /> VND</td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty report.dailyRevenue}">
                        <tr><td colspan="3" class="text-center text-muted">Không có dữ liệu trong khoảng thời gian này.</td></tr>
                    </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    <div class="col-md-6">
        <div class="card">
            <div class="card-header"><i class="fas fa-bed mr-2"></i>Doanh thu theo loại phòng</div>
            <div class="card-body table-responsive">
                <table class="table table-bordered table-hover">
                    <thead><tr><th>Loại phòng</th><th>Số booking</th><th>Doanh thu</th></tr></thead>
                    <tbody>
                    <c:forEach var="r" items="${report.roomTypeRevenue}">
                        <tr>
                            <td>${r.typeName}</td>
                            <td>${r.bookingCount}</td>
                            <td><fmt:formatNumber value="${r.totalAmount}" type="number" groupingUsed="true" /> VND</td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty report.roomTypeRevenue}">
                        <tr><td colspan="3" class="text-center text-muted">Không có dữ liệu trong khoảng thời gian này.</td></tr>
                    </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>
<%@ include file="../layout/footer.jsp" %>
