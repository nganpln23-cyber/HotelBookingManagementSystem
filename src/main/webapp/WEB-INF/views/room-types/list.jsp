<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Quản lý loại phòng" />
<%@ include file="../layout/header.jsp" %>
<div class="card">
    <div class="card-header">
        <a href="${pageContext.request.contextPath}/admin/room-types/new" class="btn btn-primary btn-sm"><i class="fas fa-plus"></i> Thêm loại phòng</a>
    </div>
    <div class="card-body table-responsive">
        <table class="table table-bordered table-hover">
            <thead><tr><th>Ảnh</th><th>ID</th><th>Tên loại</th><th>Giá/đêm</th><th>Số khách</th><th>Mô tả</th><th width="160">Thao tác</th></tr></thead>
            <tbody>
            <c:forEach var="rt" items="${roomTypes}">
                <tr>
                    <td>
                        <c:set var="thumbUrl" value="${rt.getImageDisplayUrl(pageContext.request.contextPath)}" />
                        <c:if test="${not empty thumbUrl}">
                            <img src="${thumbUrl}" alt="" class="rounded" style="width: 80px; height: 56px; object-fit: cover;">
                        </c:if>
                    </td>
                    <td>${rt.id}</td>
                    <td>${rt.typeName}</td>
                    <td><fmt:formatNumber value="${rt.pricePerNight}" type="number" groupingUsed="true" /> VND</td>
                    <td>${rt.maxGuests}</td>
                    <td>${rt.description}</td>
                    <td>
                        <a class="btn btn-warning btn-sm" href="${pageContext.request.contextPath}/admin/room-types/edit/${rt.id}">Sửa</a>
                        <a class="btn btn-danger btn-sm" onclick="return confirm('Xóa loại phòng này?')" href="${pageContext.request.contextPath}/admin/room-types/delete/${rt.id}">Xóa</a>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
</div>
<%@ include file="../layout/footer.jsp" %>
