<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Thông tin khách hàng" />
<%@ include file="../layout/header.jsp" %>
<div class="card">
    <form method="post" action="${pageContext.request.contextPath}/admin/customers/save">
        <div class="card-body">
            <input type="hidden" name="id" value="${customer.id}">
            <div class="form-group"><label>Họ tên</label><input class="form-control" name="fullName" value="${customer.fullName}" required></div>
            <div class="form-group"><label>Điện thoại</label><input class="form-control" type="tel" name="phone" value="${customer.phone}"
                pattern="[0-9]{9,11}" title="Chỉ nhập số, 9-11 chữ số"
                oninput="this.value=this.value.replace(/[^0-9]/g,'')" required></div>
            <div class="form-group"><label>Email</label><input class="form-control" type="email" name="email" value="${customer.email}" required></div>
            <div class="form-group"><label>CCCD/Passport</label><input class="form-control" name="identityNumber" value="${customer.identityNumber}" required></div>
            <div class="form-group"><label>Địa chỉ</label><textarea class="form-control" name="address" rows="3">${customer.address}</textarea></div>
        </div>
        <div class="card-footer"><button class="btn btn-primary">Lưu</button><a href="${pageContext.request.contextPath}/admin/customers" class="btn btn-secondary">Quay lại</a></div>
    </form>
</div>
<%@ include file="../layout/footer.jsp" %>
