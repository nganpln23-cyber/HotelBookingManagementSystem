<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Thông tin booking" />
<%@ include file="../layout/header.jsp" %>
<div class="card">
    <form method="post" action="${pageContext.request.contextPath}/admin/bookings/save">
        <div class="card-body">
            <input type="hidden" name="id" value="${booking.id}">
            <div class="form-group"><label>Khách hàng</label>
                <select class="form-control" name="customerId" id="customerSelect" onchange="toggleNewCustomer()">
                    <option value="">+ Thêm khách hàng mới</option>
                    <c:forEach var="c" items="${customers}">
                        <option value="${c.id}" ${booking.customerId == c.id ? 'selected' : ''}>${c.fullName} - ${c.phone}</option>
                    </c:forEach>
                </select>
            </div>
            <div id="newCustomerFields" class="border rounded p-3 mb-3 bg-light">
                <h6 class="mb-3">Thông tin khách hàng mới</h6>
                <div class="form-row">
                    <div class="form-group col-md-6"><label>Họ tên</label><input class="form-control" name="newCustomerFullName" id="newCustomerFullName" value=""></div>
                    <div class="form-group col-md-6"><label>Số điện thoại</label><input class="form-control" name="newCustomerPhone" id="newCustomerPhone" value=""></div>
                </div>
                <div class="form-row">
                    <div class="form-group col-md-6"><label>Email</label><input class="form-control" type="email" name="newCustomerEmail" value=""></div>
                    <div class="form-group col-md-6"><label>CCCD/Passport</label><input class="form-control" name="newCustomerIdentityNumber" value=""></div>
                </div>
                <div class="form-group"><label>Địa chỉ</label><input class="form-control" name="newCustomerAddress" value=""></div>
            </div>
            <div class="form-group"><label>Phòng</label>
                <select class="form-control" name="roomId" required>
                    <c:forEach var="r" items="${rooms}">
                        <option value="${r.id}" ${booking.roomId == r.id ? 'selected' : ''}>${r.roomNumber} - ${r.roomType.typeName} - ${r.status}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="form-row">
                <div class="form-group col-md-6"><label>Ngày nhận phòng</label><input class="form-control" type="text" id="checkInDate" name="checkInDate" value="${booking.checkInDate}" placeholder="Chọn ngày" autocomplete="off" required></div>
                <div class="form-group col-md-6"><label>Ngày trả phòng</label><input class="form-control" type="text" id="checkOutDate" name="checkOutDate" value="${booking.checkOutDate}" placeholder="Chọn ngày" autocomplete="off" required></div>
            </div>
            <div class="form-group"><label>Trạng thái</label>
                <select class="form-control" name="status">
                    <option value="PENDING" ${booking.status == 'PENDING' ? 'selected' : ''}>PENDING</option>
                    <option value="CONFIRMED" ${booking.status == 'CONFIRMED' ? 'selected' : ''}>CONFIRMED</option>
                    <option value="CHECKED_IN" ${booking.status == 'CHECKED_IN' ? 'selected' : ''}>CHECKED_IN</option>
                    <option value="CHECKED_OUT" ${booking.status == 'CHECKED_OUT' ? 'selected' : ''}>CHECKED_OUT</option>
                    <option value="CANCELLED" ${booking.status == 'CANCELLED' ? 'selected' : ''}>CANCELLED</option>
                </select>
            </div>
            <div class="form-group"><label>Ghi chú</label><textarea class="form-control" name="note" rows="3">${booking.note}</textarea></div>
            <p class="text-muted">Tổng tiền sẽ tự tính theo loại phòng × số đêm khi lưu.</p>
        </div>
        <div class="card-footer"><button class="btn btn-primary">Lưu</button><a href="${pageContext.request.contextPath}/admin/bookings" class="btn btn-secondary">Quay lại</a></div>
    </form>
</div>
<script>
function toggleNewCustomer() {
    var select = document.getElementById('customerSelect');
    var fields = document.getElementById('newCustomerFields');
    var nameInput = document.getElementById('newCustomerFullName');
    var phoneInput = document.getElementById('newCustomerPhone');
    var isNew = select.value === '';
    fields.style.display = isNew ? 'block' : 'none';
    nameInput.required = isNew;
    phoneInput.required = isNew;
}
toggleNewCustomer();

var checkOutPicker = flatpickr("#checkOutDate", {
    locale: "vn",
    dateFormat: "Y-m-d",
    altInput: true,
    altFormat: "d/m/Y"
});
flatpickr("#checkInDate", {
    locale: "vn",
    dateFormat: "Y-m-d",
    altInput: true,
    altFormat: "d/m/Y",
    onChange: function (selectedDates) {
        if (selectedDates[0]) {
            checkOutPicker.set("minDate", new Date(selectedDates[0].getTime() + 86400000));
        }
    }
});
</script>
<%@ include file="../layout/footer.jsp" %>
