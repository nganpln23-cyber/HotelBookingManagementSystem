<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Thanh toán booking #${booking.id}" />
<%@ include file="../layout/header.jsp" %>

<div class="row">
    <%-- Booking info --%>
    <div class="col-lg-5 mb-4">
        <div class="card h-100">
            <div class="card-header"><i class="fas fa-file-invoice text-brand"></i> Thông tin đặt phòng</div>
            <div class="card-body">
                <c:if test="${redirectAction == 'checkout'}">
                    <div class="alert alert-warning mb-3">
                        <i class="fas fa-exclamation-triangle"></i>
                        Cần thanh toán đủ trước khi check-out.
                    </div>
                </c:if>

                <table class="table table-borderless mb-0" style="font-size:.875rem;">
                    <tr><td style="color:#64748b;font-weight:600;width:140px;padding:.4rem 0;">Mã booking</td>
                        <td style="padding:.4rem 0;"><strong>#${booking.id}</strong>
                            <c:if test="${not empty booking.confirmationCode}">
                                &nbsp;<span class="code-chip code-confirm"><i class="fas fa-barcode" style="font-size:.62rem;"></i>${booking.confirmationCode}</span>
                            </c:if>
                        </td></tr>
                    <tr><td style="color:#64748b;font-weight:600;padding:.4rem 0;">Khách hàng</td>
                        <td style="padding:.4rem 0;font-weight:700;">${booking.customerName}</td></tr>
                    <tr><td style="color:#64748b;font-weight:600;padding:.4rem 0;">Phòng</td>
                        <td style="padding:.4rem 0;">${booking.roomNumber} &mdash; ${booking.roomTypeName}</td></tr>
                    <tr><td style="color:#64748b;font-weight:600;padding:.4rem 0;">Nhận phòng</td>
                        <td style="padding:.4rem 0;">${booking.checkInDate}</td></tr>
                    <tr><td style="color:#64748b;font-weight:600;padding:.4rem 0;">Trả phòng</td>
                        <td style="padding:.4rem 0;">${booking.checkOutDate}</td></tr>
                    <tr><td style="color:#64748b;font-weight:600;padding:.4rem 0;">Tổng tiền</td>
                        <td style="padding:.4rem 0;font-weight:700;font-size:1rem;">
                            <fmt:formatNumber value="${booking.totalAmount}" type="number" groupingUsed="true" />đ
                        </td></tr>
                    <tr style="border-top:2px solid #e2e8f0;">
                        <td style="color:#dc2626;font-weight:700;padding:.5rem 0;">Còn phải thu</td>
                        <td style="padding:.5rem 0;font-weight:800;font-size:1.15rem;color:#dc2626;">
                            <fmt:formatNumber value="${amountDue}" type="number" groupingUsed="true" />đ
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>

    <%-- QR payment --%>
    <div class="col-lg-3 mb-4">
        <div class="card h-100">
            <div class="card-header"><i class="fas fa-qrcode text-brand"></i> QR Chuyển khoản</div>
            <div class="card-body text-center">
                <div style="font-size:.78rem;color:#64748b;margin-bottom:.75rem;">
                    Quét mã QR để thanh toán nhanh
                </div>
                <img src="https://img.vietqr.io/image/MB-9704216220071437-compact2.png?amount=<fmt:formatNumber value="${amountDue}" type="number" groupingUsed="false" maxFractionDigits="0"/>&addInfo=TT+${not empty booking.confirmationCode ? booking.confirmationCode : 'BK'.concat(booking.id)}&accountName=KHACH+SAN+ABC"
                     alt="QR thanh toán"
                     style="max-width:180px;border-radius:.5rem;border:1px solid #e2e8f0;"
                     onerror="this.style.display='none';document.getElementById('qr-fallback').style.display='block'">
                <div id="qr-fallback" style="display:none;">
                    <div id="qrcode-js" style="display:flex;justify-content:center;"></div>
                </div>
                <div style="margin-top:.75rem;font-size:.75rem;color:#475569;line-height:1.7;">
                    <div><strong>MB Bank</strong></div>
                    <div>STK: 9704216220071437</div>
                    <div>Nội dung: TT ${not empty booking.confirmationCode ? booking.confirmationCode : 'BK'.concat(booking.id)}</div>
                    <div>Số tiền: <strong style="color:#4f46e5;">
                        <fmt:formatNumber value="${amountDue}" type="number" groupingUsed="true" />đ
                    </strong></div>
                </div>
            </div>
        </div>
    </div>

    <%-- Payment form --%>
    <div class="col-lg-4 mb-4">
        <div class="card h-100">
            <div class="card-header"><i class="fas fa-cash-register text-brand"></i> Nhập thanh toán</div>
            <div class="card-body">
                <form action="${pageContext.request.contextPath}/admin/payments/pay" method="post">
                    <input type="hidden" name="bookingId" value="${booking.id}">
                    <input type="hidden" name="redirectAction" value="${redirectAction}">

                    <div class="form-group">
                        <label>Số tiền thanh toán</label>
                        <input type="text" inputmode="numeric" name="amount" class="form-control money-input"
                               value="${amountDue}" required style="font-size:1rem;font-weight:700;height:46px;">
                    </div>

                    <div class="form-group">
                        <label>Phương thức</label>
                        <div class="row" style="gap:.5rem;margin:0;">
                            <label class="pay-method-opt">
                                <input type="radio" name="method" value="CASH" checked>
                                <div class="pay-method-card">
                                    <i class="fas fa-money-bill-wave"></i><div>Tiền mặt</div>
                                </div>
                            </label>
                            <label class="pay-method-opt">
                                <input type="radio" name="method" value="BANK_TRANSFER">
                                <div class="pay-method-card">
                                    <i class="fas fa-university"></i><div>Chuyển khoản</div>
                                </div>
                            </label>
                            <label class="pay-method-opt">
                                <input type="radio" name="method" value="CARD">
                                <div class="pay-method-card">
                                    <i class="fas fa-credit-card"></i><div>Thẻ</div>
                                </div>
                            </label>
                            <label class="pay-method-opt">
                                <input type="radio" name="method" value="EWALLET">
                                <div class="pay-method-card">
                                    <i class="fas fa-mobile-alt"></i><div>Ví điện tử</div>
                                </div>
                            </label>
                        </div>
                    </div>

                    <div class="form-group">
                        <label>Ghi chú</label>
                        <textarea name="note" class="form-control" rows="2" placeholder="Nhập ghi chú..."></textarea>
                    </div>

                    <button type="submit" class="btn btn-success btn-block">
                        <i class="fas fa-check-circle mr-1"></i>Xác nhận thanh toán
                    </button>
                    <a href="${pageContext.request.contextPath}/admin/bookings/invoice/${booking.id}"
                       target="_blank" class="btn btn-dark btn-block btn-sm mt-2">
                        <i class="fas fa-print mr-1"></i>In hóa đơn
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/payments" class="btn btn-light btn-block btn-sm mt-1">Hủy</a>
                </form>
            </div>
        </div>
    </div>
</div>

<style>
.pay-method-opt { cursor: pointer; margin: 0; }
.pay-method-opt input { display: none; }
.pay-method-card {
    border: 2px solid #e2e8f0;
    border-radius: .5rem;
    padding: .5rem .75rem;
    text-align: center;
    font-size: .72rem;
    font-weight: 600;
    color: #64748b;
    min-width: 70px;
    transition: all .15s;
    cursor: pointer;
}
.pay-method-card i { display: block; font-size: 1.1rem; margin-bottom: .25rem; }
.pay-method-opt input:checked + .pay-method-card {
    border-color: #4f46e5;
    background: #eef2ff;
    color: #4f46e5;
}
.pay-method-opt:hover .pay-method-card { border-color: #a5b4fc; }
.row.pay-opts { gap: .4rem !important; }
</style>

<script src="https://cdn.jsdelivr.net/npm/qrcode@1.5.3/build/qrcode.min.js"></script>
<script>
(function () {
    var fb = document.getElementById('qrcode-js');
    if (!fb || !window.QRCode) return;
    var code = '${not empty booking.confirmationCode ? booking.confirmationCode : "BK".concat(booking.id)}';
    var amount = ${amountDue};
    new QRCode(fb, {
        text: 'MB|9704216220071437|TT ' + code + '|' + amount,
        width: 170, height: 170,
        colorDark: '#1e1b4b',
        colorLight: '#ffffff',
        correctLevel: QRCode.CorrectLevel.M
    });
})();
</script>

<%@ include file="../layout/footer.jsp" %>
