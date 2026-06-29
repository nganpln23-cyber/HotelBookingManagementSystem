<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="${empty employee.id ? 'Thêm nhân viên' : 'Sửa nhân viên'}" />
<%@ include file="../layout/header.jsp" %>

<div class="row justify-content-center">
    <div class="col-lg-8">
        <div class="card">
            <div class="card-header">
                <i class="fas fa-user-tie mr-1"></i>
                ${empty employee.id ? 'Thêm nhân viên mới' : 'Chỉnh sửa: '.concat(employee.fullName)}
            </div>
            <div class="card-body">
                <form action="${pageContext.request.contextPath}/admin/employees/save" method="post">
                    <input type="hidden" name="id" value="${employee.id}">

                    <div class="row">
                        <div class="col-md-6 form-group">
                            <label>Họ và tên <span class="text-danger">*</span></label>
                            <input type="text" name="fullName" class="form-control" value="${employee.fullName}" required placeholder="Nguyễn Văn A">
                        </div>
                        <div class="col-md-6 form-group">
                            <label>Số điện thoại</label>
                            <input type="text" name="phone" class="form-control" value="${employee.phone}" placeholder="0901234567">
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-6 form-group">
                            <label>Email</label>
                            <input type="email" name="email" class="form-control" value="${employee.email}" placeholder="email@grandbeach.vn">
                        </div>
                        <div class="col-md-6 form-group">
                            <label>CCCD / Passport</label>
                            <input type="text" name="identityNumber" class="form-control" value="${employee.identityNumber}" placeholder="012345678901">
                        </div>
                    </div>

                    <div class="form-group">
                        <label>Địa chỉ</label>
                        <input type="text" name="address" class="form-control" value="${employee.address}" placeholder="Quận, Tỉnh/Thành">
                    </div>

                    <div class="row">
                        <div class="col-md-6 form-group">
                            <label>Chức vụ <span class="text-danger">*</span></label>
                            <input type="text" name="position" class="form-control" value="${employee.position}" required placeholder="Lễ tân, Đầu bếp...">
                        </div>
                        <div class="col-md-6 form-group">
                            <label>Phòng ban <span class="text-danger">*</span></label>
                            <input type="text" name="department" class="form-control" value="${employee.department}" required placeholder="Lễ tân, Bếp, Bảo vệ...">
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-4 form-group">
                            <label>Ngày vào làm</label>
                            <input type="text" id="hireDate" name="hireDate" class="form-control" value="${employee.hireDate}" placeholder="yyyy-mm-dd" autocomplete="off">
                        </div>
                        <div class="col-md-4 form-group">
                            <label>Lương (VND)</label>
                            <input type="number" name="salary" class="form-control" value="${employee.salary}" placeholder="0" min="0">
                        </div>
                        <div class="col-md-4 form-group">
                            <label>Trạng thái</label>
                            <select name="status" class="form-control">
                                <option value="ACTIVE"   ${employee.status == 'ACTIVE'   ? 'selected' : ''}>Đang làm</option>
                                <option value="ON_LEAVE" ${employee.status == 'ON_LEAVE' ? 'selected' : ''}>Nghỉ phép</option>
                                <option value="INACTIVE" ${employee.status == 'INACTIVE' ? 'selected' : ''}>Đã nghỉ việc</option>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label>Ghi chú</label>
                        <textarea name="note" class="form-control" rows="2" placeholder="Ghi chú thêm...">${employee.note}</textarea>
                    </div>

                    <div class="d-flex" style="gap:.5rem;">
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-save mr-1"></i>Lưu
                        </button>
                        <a href="${pageContext.request.contextPath}/admin/employees" class="btn btn-light">Hủy</a>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<script>
flatpickr("#hireDate", { locale: "vn", dateFormat: "Y-m-d", altInput: true, altFormat: "d/m/Y" });
</script>

<%@ include file="../layout/footer.jsp" %>
