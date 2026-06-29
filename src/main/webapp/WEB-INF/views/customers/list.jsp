<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Quản lý khách hàng" />
<%@ include file="../layout/header.jsp" %>

<div class="d-flex align-items-center justify-content-between mb-3" style="gap:.5rem;flex-wrap:wrap;">
    <a href="${pageContext.request.contextPath}/admin/customers/new" class="btn btn-primary btn-sm">
        <i class="fas fa-plus"></i> Thêm khách hàng
    </a>
    <form method="get" action="${pageContext.request.contextPath}/admin/customers" class="d-flex" style="gap:.4rem;">
        <div class="input-group input-group-sm" style="width:280px;">
            <input type="text" name="keyword" class="form-control" placeholder="Tìm tên, SĐT, email, CCCD..." value="${keyword}">
            <div class="input-group-append">
                <button class="btn btn-outline-secondary" type="submit"><i class="fas fa-search"></i></button>
            </div>
        </div>
        <c:if test="${not empty keyword}">
            <a href="${pageContext.request.contextPath}/admin/customers" class="btn btn-sm btn-outline-danger"><i class="fas fa-times"></i></a>
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
                    <th>Họ tên</th>
                    <th>Điện thoại</th>
                    <th>Email</th>
                    <th>CCCD / Passport</th>
                    <th>Địa chỉ</th>
                    <th width="110">Thao tác</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="c" items="${customers}">
                    <tr>
                        <td class="text-muted" style="font-size:.78rem;">#${c.id}</td>
                        <td style="font-weight:600;">${c.fullName}</td>
                        <td>${c.phone}</td>
                        <td>${c.email}</td>
                        <td>${c.identityNumber}</td>
                        <td>${c.address}</td>
                        <td>
                            <div class="action-btn-group">
                                <a class="btn btn-sm btn-light" href="${pageContext.request.contextPath}/admin/customers/edit/${c.id}"><i class="fas fa-pen"></i></a>
                                <a class="btn btn-sm btn-danger" onclick="return confirm('Xóa khách hàng này?')" href="${pageContext.request.contextPath}/admin/customers/delete/${c.id}"><i class="fas fa-trash"></i></a>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty customers}">
                    <tr>
                        <td colspan="7" class="text-center text-muted py-5">
                            <i class="fas fa-users fa-2x mb-2 d-block"></i>
                            <c:choose>
                                <c:when test="${not empty keyword}">Không tìm thấy khách hàng khớp với "<strong>${keyword}</strong>"</c:when>
                                <c:otherwise>Chưa có khách hàng nào.</c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                </c:if>
                </tbody>
            </table>
        </div>
    </div>
    <c:if test="${not empty keyword}">
        <div class="card-footer text-muted" style="font-size:.8rem;">
            Tìm thấy <strong>${customers.size()}</strong> kết quả cho "<strong>${keyword}</strong>"
        </div>
    </c:if>
</div>

<%@ include file="../layout/footer.jsp" %>
