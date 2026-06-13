<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Thông tin phòng" />
<%@ include file="../layout/header.jsp" %>
<div class="card">
    <form method="post" action="${pageContext.request.contextPath}/admin/rooms/save">
        <div class="card-body">
            <input type="hidden" name="id" value="${room.id}">
            <div class="form-group"><label>Số phòng</label><input class="form-control" name="roomNumber" value="${room.roomNumber}" required></div>
            <div class="form-group"><label>Loại phòng</label>
                <select class="form-control" name="roomTypeId" required>
                    <c:forEach var="rt" items="${roomTypes}">
                        <option value="${rt.id}" ${room.roomTypeId == rt.id ? 'selected' : ''}>${rt.typeName}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="form-group"><label>Tầng</label><input class="form-control" type="number" name="floor" value="${room.floor}" required></div>
            <div class="form-group"><label>Trạng thái</label>
                <select class="form-control" name="status">
                    <option value="AVAILABLE" ${room.status == 'AVAILABLE' ? 'selected' : ''}>AVAILABLE</option>
                    <option value="BOOKED" ${room.status == 'BOOKED' ? 'selected' : ''}>BOOKED</option>
                    <option value="OCCUPIED" ${room.status == 'OCCUPIED' ? 'selected' : ''}>OCCUPIED</option>
                    <option value="MAINTENANCE" ${room.status == 'MAINTENANCE' ? 'selected' : ''}>MAINTENANCE</option>
                </select>
            </div>
            <div class="form-group"><label>Mô tả</label><textarea class="form-control" name="description" rows="3">${room.description}</textarea></div>
        </div>
        <div class="card-footer"><button class="btn btn-primary">Lưu</button><a href="${pageContext.request.contextPath}/admin/rooms" class="btn btn-secondary">Quay lại</a></div>
    </form>
</div>
<%@ include file="../layout/footer.jsp" %>
