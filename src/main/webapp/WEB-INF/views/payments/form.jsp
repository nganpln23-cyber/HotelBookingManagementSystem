<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Thanh toán booking #${booking.id}" />
<%@ include file="../layout/header.jsp" %>
<div class="row">
    <div class="col-md-6">
        <div class="card">
            <div class="card-header"><i class="fas fa-receipt mr-2"></i>Thông tin booking</div>
            <div class="card-body">
                <c:if test="${redirectAction == 'checkout'}">
                    <div class="alert alert-warning">
                        <i class="fas fa-exclamation-triangle mr-1"></i>
                        Cần thanh toán đủ trước khi check-out.
                    </div>
                </c:if>
                <table class="table table-borderless mb-0">
                    <tr><th width="160">Khách hàng</th><td>${booking.customerName}</td></tr>
                    <tr><th>Phòng</th><td>${booking.roomNumber} - ${booking.roomTypeName}</td></tr>
                    <tr><th>Ngày nhận</th><td>${booking.checkInDate}</td></tr>
                    <tr><th>Ngày trả</th><td>${booking.checkOutDate}</td></tr>
                    <tr><th>Tổng tiền</th><td><fmt:formatNumber value="${booking.totalAmount}" type="number" groupingUsed="true" /> VND</td></tr>
                    <tr><th>Đã thanh toán</th><td><fmt:formatNumber value="${booking.totalAmount - amountDue}" type="number" groupingUsed="true" /> VND</td></tr>
                    <tr><th>Còn phải thu</th><td><strong class="text-danger"><fmt:formatNumber value="${amountDue}" type="number" groupingUsed="true" /> VND</strong></td></tr>
                </table>
            </div>
        </div>
    </div>
    <div class="col-md-6">
        <div class="card">
            <div class="card-header"><i class="fas fa-cash-register mr-2"></i>Giả lập thanh toán</div>
            <div class="card-body">
                <form action="${pageContext.request.contextPath}/admin/payments/pay" method="post">
                    <input type="hidden" name="bookingId" value="${booking.id}">
                    <input type="hidden" name="redirectAction" value="${redirectAction}">
                    <div class="form-group">
                        <label>Số tiền thanh toán</label>
                        <input type="text" inputmode="numeric" name="amount" class="form-control money-input" value="${amountDue}" required>
                    </div>
                    <div class="form-group">
                        <label>Phương thức</label>
                        <select name="method" class="form-control" required>
                            <option value="CASH">Tiền mặt</option>
                            <option value="CARD">Thẻ</option>
                            <option value="BANK_TRANSFER">Chuyển khoản</option>
                            <option value="EWALLET">Ví điện tử</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Ghi chú</label>
                        <textarea name="note" class="form-control" rows="2"></textarea>
                    </div>
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-check-circle mr-1"></i>Xác nhận thanh toán (giả lập)
                    </button>
                    <a href="${pageContext.request.contextPath}/admin/payments" class="btn btn-light">Hủy</a>
                </form>
            </div>
        </div>
    </div>
</div>
<%@ include file="../layout/footer.jsp" %>
