<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Thông tin loại phòng" />
<%@ include file="../layout/header.jsp" %>
<div class="card">
    <form method="post" action="${pageContext.request.contextPath}/admin/room-types/save" enctype="multipart/form-data">
        <div class="card-body">
            <input type="hidden" name="id" value="${roomType.id}">
            <div class="form-group"><label>Tên loại phòng</label><input class="form-control" name="typeName" value="${roomType.typeName}" required></div>
            <div class="form-group"><label>Giá mỗi đêm</label><input class="form-control money-input" type="text" inputmode="numeric" name="pricePerNight" value="${roomType.pricePerNight}" required></div>
            <div class="form-group"><label>Số khách tối đa</label><input class="form-control" type="number" name="maxGuests" value="${roomType.maxGuests}" required></div>
            <div class="form-group"><label>Mô tả</label><textarea class="form-control" name="description" rows="3">${roomType.description}</textarea></div>
            <div class="form-group">
                <label>Tải ảnh minh họa lên</label>
                <input type="file" class="form-control-file d-block" name="imageFile" accept="image/*">
                <small class="form-text text-muted">Ảnh tải lên sẽ được lưu trong cơ sở dữ liệu và ưu tiên hiển thị thay cho URL bên dưới (tối đa 5MB).</small>
            </div>
            <div class="form-group"><label>Hoặc nhập URL ảnh minh họa</label><input class="form-control" name="imageUrl" value="${roomType.imageUrl}" placeholder="https://..."></div>
            <c:set var="previewUrl" value="${roomType.getImageDisplayUrl(pageContext.request.contextPath)}" />
            <c:if test="${not empty previewUrl}">
                <div class="form-group">
                    <label>Ảnh hiện tại</label><br>
                    <img src="${previewUrl}" alt="" class="rounded" style="max-width: 240px; max-height: 140px; object-fit: cover;">
                </div>
            </c:if>
        </div>
        <div class="card-footer">
            <button class="btn btn-primary">Lưu</button>
            <a href="${pageContext.request.contextPath}/admin/room-types" class="btn btn-secondary">Quay lại</a>
        </div>
    </form>
</div>
<%@ include file="../layout/footer.jsp" %>
