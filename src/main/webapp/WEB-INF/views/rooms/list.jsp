<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Quản lý phòng" />
<%@ include file="../layout/header.jsp" %>
<div class="card">
    <div class="card-header"><a href="${pageContext.request.contextPath}/admin/rooms/new" class="btn btn-primary btn-sm"><i class="fas fa-plus"></i> Thêm phòng</a></div>
    <div class="card-body table-responsive">
        <table class="table table-bordered table-hover">
            <thead><tr><th>ID</th><th>Số phòng</th><th>Loại phòng</th><th>Tầng</th><th>Trạng thái</th><th>Mô tả</th><th width="150">Thao tác</th></tr></thead>
            <tbody>
            <c:forEach var="r" items="${rooms}">
                <tr>
                    <td>${r.id}</td>
                    <td>${r.roomNumber}</td>
                    <td>${r.roomType.typeName} - <fmt:formatNumber value="${r.roomType.pricePerNight}" type="number" groupingUsed="true" /> VND</td>
                    <td>${r.floor}</td>
                    <td><span class="badge badge-status-${r.status}">${r.status}</span></td>
                    <td>${r.description}</td>
                    <td>
                        <a class="btn btn-warning btn-sm" href="${pageContext.request.contextPath}/admin/rooms/edit/${r.id}">Sửa</a>
                        <a class="btn btn-danger btn-sm" onclick="return confirm('Xóa phòng này?')" href="${pageContext.request.contextPath}/admin/rooms/delete/${r.id}">Xóa</a>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
</div>
<%@ include file="../layout/footer.jsp" %>
