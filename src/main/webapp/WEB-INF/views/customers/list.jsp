<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Quản lý khách hàng" />
<%@ include file="../layout/header.jsp" %>
<div class="card">
    <div class="card-header"><a href="${pageContext.request.contextPath}/admin/customers/new" class="btn btn-primary btn-sm"><i class="fas fa-plus"></i> Thêm khách hàng</a></div>
    <div class="card-body table-responsive">
        <table class="table table-bordered table-hover">
            <thead><tr><th>ID</th><th>Họ tên</th><th>Điện thoại</th><th>Email</th><th>CCCD/Passport</th><th>Địa chỉ</th><th width="150">Thao tác</th></tr></thead>
            <tbody>
            <c:forEach var="c" items="${customers}">
                <tr>
                    <td>${c.id}</td><td>${c.fullName}</td><td>${c.phone}</td><td>${c.email}</td><td>${c.identityNumber}</td><td>${c.address}</td>
                    <td>
                        <a class="btn btn-warning btn-sm" href="${pageContext.request.contextPath}/admin/customers/edit/${c.id}">Sửa</a>
                        <a class="btn btn-danger btn-sm" onclick="return confirm('Xóa khách hàng này?')" href="${pageContext.request.contextPath}/admin/customers/delete/${c.id}">Xóa</a>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
</div>
<%@ include file="../layout/footer.jsp" %>
