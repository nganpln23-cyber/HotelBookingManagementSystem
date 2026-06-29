<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Quản lý nhân viên" />
<%@ include file="../layout/header.jsp" %>

<div class="d-flex align-items-center justify-content-between mb-3" style="gap:.5rem;flex-wrap:wrap;">
    <a href="${pageContext.request.contextPath}/admin/employees/new" class="btn btn-primary btn-sm">
        <i class="fas fa-plus"></i> Thêm nhân viên
    </a>
    <form method="get" action="${pageContext.request.contextPath}/admin/employees" class="d-flex" style="gap:.4rem;">
        <input type="text" name="q" value="${q}" class="form-control form-control-sm" placeholder="Tìm tên, chức vụ, phòng ban..." style="width:260px;">
        <button type="submit" class="btn btn-outline-secondary btn-sm"><i class="fas fa-search"></i></button>
    </form>
</div>

<div class="card">
    <div class="card-body p-0">
        <div class="table-responsive">
            <table class="table table-hover mb-0">
                <thead>
                <tr>
                    <th>#</th>
                    <th>Họ tên</th>
                    <th>Chức vụ</th>
                    <th>Phòng ban</th>
                    <th>SĐT</th>
                    <th>Ngày vào</th>
                    <th>Lương</th>
                    <th>Trạng thái</th>
                    <th>Thao tác</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="e" items="${employees}">
                    <tr>
                        <td class="text-muted" style="font-size:.78rem;">#${e.id}</td>
                        <td>
                            <div style="font-weight:600;">${e.fullName}</div>
                            <div style="font-size:.75rem;color:#64748b;">${e.email}</div>
                        </td>
                        <td>${e.position}</td>
                        <td>${e.department}</td>
                        <td style="white-space:nowrap;">${e.phone}</td>
                        <td style="white-space:nowrap;">${e.hireDate}</td>
                        <td style="white-space:nowrap;font-weight:600;">
                            <fmt:formatNumber value="${e.salary}" type="number" groupingUsed="true"/>đ
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${e.status == 'ACTIVE'}">
                                    <span class="badge badge-status-CONFIRMED">Đang làm</span>
                                </c:when>
                                <c:when test="${e.status == 'ON_LEAVE'}">
                                    <span class="badge badge-status-PENDING">Nghỉ phép</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge badge-status-CANCELLED">Đã nghỉ việc</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <div class="action-btn-group">
                                <a class="btn btn-sm btn-light"
                                   href="${pageContext.request.contextPath}/admin/employees/edit/${e.id}"
                                   title="Chỉnh sửa"><i class="fas fa-pen"></i></a>
                                <a class="btn btn-sm btn-danger"
                                   href="${pageContext.request.contextPath}/admin/employees/delete/${e.id}"
                                   onclick="return confirm('Xóa nhân viên ${e.fullName}?')"
                                   title="Xóa"><i class="fas fa-trash"></i></a>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty employees}">
                    <tr>
                        <td colspan="9" class="text-center text-muted py-5">
                            <i class="fas fa-users fa-2x mb-3 d-block"></i>
                            Chưa có nhân viên nào.
                        </td>
                    </tr>
                </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>

<%@ include file="../layout/footer.jsp" %>
