<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Quản lý phòng" />
<%@ include file="../layout/header.jsp" %>

<div class="d-flex align-items-center justify-content-between mb-3" style="gap:.5rem;flex-wrap:wrap;">
    <div class="d-flex" style="gap:.4rem;">
        <a href="${pageContext.request.contextPath}/admin/rooms/new" class="btn btn-primary btn-sm">
            <i class="fas fa-plus"></i> Thêm phòng
        </a>
        <a href="${pageContext.request.contextPath}/admin/rooms/sync-status" class="btn btn-outline-secondary btn-sm" title="Đồng bộ trạng thái phòng theo booking thực tế">
            <i class="fas fa-sync-alt"></i> Đồng bộ trạng thái
        </a>
    </div>
    <form method="get" action="${pageContext.request.contextPath}/admin/rooms" class="d-flex align-items-center" style="gap:.4rem;flex-wrap:wrap;">
        <div class="input-group input-group-sm" style="width:220px;">
            <input type="text" name="keyword" class="form-control" placeholder="Số phòng, loại phòng..." value="${keyword}">
            <div class="input-group-append">
                <button class="btn btn-outline-secondary" type="submit"><i class="fas fa-search"></i></button>
            </div>
        </div>
        <select name="status" class="form-control form-control-sm" style="width:160px;" onchange="this.form.submit()">
            <option value="">-- Tất cả trạng thái --</option>
            <option value="AVAILABLE" ${filterStatus == 'AVAILABLE' ? 'selected' : ''}>Còn trống</option>
            <option value="BOOKED"    ${filterStatus == 'BOOKED'    ? 'selected' : ''}>Đã đặt</option>
            <option value="OCCUPIED"  ${filterStatus == 'OCCUPIED'  ? 'selected' : ''}>Đang có khách</option>
            <option value="MAINTENANCE" ${filterStatus == 'MAINTENANCE' ? 'selected' : ''}>Bảo trì</option>
        </select>
        <c:if test="${not empty keyword or not empty filterStatus}">
            <a href="${pageContext.request.contextPath}/admin/rooms" class="btn btn-sm btn-outline-danger"><i class="fas fa-times"></i></a>
        </c:if>
    </form>
</div>

<div class="card">
    <div class="card-body p-0">
        <div class="table-responsive">
            <table class="table table-hover mb-0">
                <thead>
                <tr>
                    <th>#</th>
                    <th>Số phòng</th>
                    <th>Loại phòng</th>
                    <th>Giá / đêm</th>
                    <th>Tầng</th>
                    <th>Trạng thái</th>
                    <th>Mô tả</th>
                    <th width="110">Thao tác</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="r" items="${rooms}">
                    <tr>
                        <td class="text-muted" style="font-size:.78rem;">#${r.id}</td>
                        <td style="font-weight:700;font-size:1rem;">${r.roomNumber}</td>
                        <td>${r.roomType.typeName}</td>
                        <td style="white-space:nowrap;font-weight:600;">
                            <fmt:formatNumber value="${r.roomType.pricePerNight}" type="number" groupingUsed="true" />đ
                        </td>
                        <td>Tầng ${r.floor}</td>
                        <td><span class="badge badge-status-${r.status}">${r.status}</span></td>
                        <td style="font-size:.82rem;color:#64748b;">${r.description}</td>
                        <td>
                            <div class="action-btn-group">
                                <a class="btn btn-sm btn-light" href="${pageContext.request.contextPath}/admin/rooms/edit/${r.id}"><i class="fas fa-pen"></i></a>
                                <a class="btn btn-sm btn-danger" onclick="return confirm('Xóa phòng ${r.roomNumber}?')" href="${pageContext.request.contextPath}/admin/rooms/delete/${r.id}"><i class="fas fa-trash"></i></a>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty rooms}">
                    <tr>
                        <td colspan="8" class="text-center text-muted py-5">
                            <i class="fas fa-door-open fa-2x mb-2 d-block"></i>
                            Không tìm thấy phòng nào.
                        </td>
                    </tr>
                </c:if>
                </tbody>
            </table>
        </div>
    </div>
    <c:if test="${not empty keyword or not empty filterStatus}">
        <div class="card-footer text-muted" style="font-size:.8rem;">
            Tìm thấy <strong>${rooms.size()}</strong> phòng
            <c:if test="${not empty keyword}"> khớp với "<strong>${keyword}</strong>"</c:if>
            <c:if test="${not empty filterStatus}"> &mdash; trạng thái <strong>${filterStatus}</strong></c:if>
        </div>
    </c:if>
</div>

<%@ include file="../layout/footer.jsp" %>
