<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Hóa đơn #${booking.id}" />
<%@ include file="../layout/header.jsp" %>

<div class="btn-print-wrap mb-3">
    <button onclick="window.print()" class="btn btn-primary btn-sm btn-print-hide">
        <i class="fas fa-print mr-1"></i>In hóa đơn
    </button>
    <a href="${pageContext.request.contextPath}/admin/bookings" class="btn btn-light btn-sm ml-1 btn-print-hide">
        <i class="fas fa-arrow-left mr-1"></i>Quay lại
    </a>
</div>

<div class="invoice-wrap">

    <%-- Header --%>
    <div class="invoice-header">
        <div class="row align-items-start">
            <div class="col-md-6">
                <div class="invoice-logo mb-1">
                    <i class="fas fa-hotel mr-2"></i>Hotel Manager
                </div>
                <div style="color:#64748b;font-size:.83rem;line-height:1.8;">
                    123 Đường ABC, Quận 1, TP.HCM<br>
                    ĐT: 028 1234 5678 | Email: hotel@hotel.vn
                </div>
            </div>
            <div class="col-md-6 text-md-right">
                <div class="invoice-title">HÓA ĐƠN</div>
                <div class="invoice-meta mt-1">
                    <div>Số hóa đơn: <strong>#${booking.id}</strong></div>
                    <div>Ngày xuất: <strong><fmt:formatDate value="<%=new java.util.Date()%>" pattern="dd/MM/yyyy HH:mm" /></strong></div>
                    <c:if test="${not empty booking.confirmationCode}">
                        <div class="mt-1">Mã đặt phòng:
                            <span class="code-chip code-confirm">
                                <i class="fas fa-barcode" style="font-size:.65rem;"></i>${booking.confirmationCode}
                            </span>
                        </div>
                    </c:if>
                    <c:if test="${not empty booking.checkinCode}">
                        <div class="mt-1">Mã nhận phòng:
                            <span class="code-chip code-checkin">
                                <i class="fas fa-key" style="font-size:.65rem;"></i>${booking.checkinCode}
                            </span>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
    </div>

    <%-- Customer + Booking info --%>
    <div class="row mb-4">
        <div class="col-md-6">
            <div style="font-size:.7rem;font-weight:700;text-transform:uppercase;letter-spacing:.07em;color:#64748b;margin-bottom:.5rem;">Thông tin khách hàng</div>
            <div style="font-weight:700;font-size:1rem;">${booking.customerName}</div>
            <div class="text-muted" style="font-size:.83rem;">Mã khách: #${booking.customerId}</div>
        </div>
        <div class="col-md-6">
            <div style="font-size:.7rem;font-weight:700;text-transform:uppercase;letter-spacing:.07em;color:#64748b;margin-bottom:.5rem;">Thông tin đặt phòng</div>
            <table style="font-size:.845rem;width:100%;">
                <tr>
                    <td style="color:#64748b;padding-bottom:.25rem;width:120px;">Phòng</td>
                    <td style="font-weight:600;">${booking.roomNumber} &mdash; ${booking.roomTypeName}</td>
                </tr>
                <tr>
                    <td style="color:#64748b;padding-bottom:.25rem;">Nhận phòng</td>
                    <td style="font-weight:600;">${booking.checkInDate}</td>
                </tr>
                <tr>
                    <td style="color:#64748b;padding-bottom:.25rem;">Trả phòng</td>
                    <td style="font-weight:600;">${booking.checkOutDate}</td>
                </tr>
                <tr>
                    <td style="color:#64748b;">Trạng thái</td>
                    <td><span class="badge badge-status-${booking.status}">${booking.status}</span></td>
                </tr>
            </table>
        </div>
    </div>

    <%-- Items table --%>
    <table class="table invoice-table mb-3">
        <thead>
        <tr>
            <th>Mô tả</th>
            <th class="text-right" style="width:140px;">Thành tiền</th>
        </tr>
        </thead>
        <tbody>
        <tr>
            <td>
                <div style="font-weight:600;">Tiền phòng ${booking.roomNumber} (${booking.roomTypeName})</div>
                <div style="font-size:.78rem;color:#64748b;">
                    Từ ${booking.checkInDate} đến ${booking.checkOutDate}
                </div>
            </td>
            <td class="text-right" style="font-weight:600;">
                <fmt:formatNumber value="${booking.totalAmount}" type="number" groupingUsed="true" />đ
            </td>
        </tr>
        <c:if test="${booking.discountAmount != null && booking.discountAmount > 0}">
            <tr>
                <td>
                    <span style="color:#059669;">Giảm giá khuyến mãi
                        <c:if test="${not empty booking.promoCode}"> (${booking.promoCode})</c:if>
                    </span>
                </td>
                <td class="text-right" style="color:#059669;">
                    -<fmt:formatNumber value="${booking.discountAmount}" type="number" groupingUsed="true" />đ
                </td>
            </tr>
        </c:if>
        </tbody>
    </table>

    <%-- Totals --%>
    <div class="invoice-total">
        <div class="row">
            <div class="col-md-6">
                <%-- QR code payment section --%>
                <c:if test="${not isFullyPaid}">
                    <div class="qr-box btn-print-hide">
                        <div style="font-size:.72rem;font-weight:700;text-transform:uppercase;letter-spacing:.06em;color:#64748b;margin-bottom:.75rem;">
                            <i class="fas fa-qrcode mr-1"></i>Quét QR thanh toán
                        </div>
                        <div id="qrcode" style="display:flex;justify-content:center;margin-bottom:.5rem;"></div>
                        <div style="font-size:.72rem;color:#64748b;">Ngân hàng MB Bank · STK: 9704216220071437</div>
                        <div style="font-size:.72rem;color:#64748b;">Nội dung: TT ${booking.confirmationCode != null ? booking.confirmationCode : 'BK'.concat(booking.id)}</div>
                    </div>
                    <div class="qr-box d-none" id="qr-print-box" style="display:none;">
                        <img src="https://img.vietqr.io/image/MB-9704216220071437-compact2.png?amount=<fmt:formatNumber value="${amountDue}" type="number" groupingUsed="false" maxFractionDigits="0"/>&addInfo=TT+${booking.confirmationCode != null ? booking.confirmationCode : 'BK'.concat(booking.id)}&accountName=KHACH+SAN+ABC"
                             alt="QR thanh toán" style="max-width:160px;">
                        <div style="font-size:.72rem;color:#64748b;margin-top:.5rem;">Ngân hàng MB Bank</div>
                        <div style="font-size:.72rem;color:#64748b;">STK: 9704216220071437</div>
                    </div>
                </c:if>
                <c:if test="${isFullyPaid}">
                    <div style="text-align:center;padding:1.5rem;background:#d1fae5;border-radius:.5rem;border:1px solid #6ee7b7;">
                        <i class="fas fa-check-circle" style="font-size:2rem;color:#059669;margin-bottom:.5rem;display:block;"></i>
                        <div style="font-weight:700;color:#065f46;">ĐÃ THANH TOÁN ĐỦ</div>
                    </div>
                </c:if>
            </div>
            <div class="col-md-6">
                <table style="width:100%;font-size:.875rem;">
                    <tr>
                        <td style="color:#64748b;padding:.3rem 0;">Tổng tiền phòng:</td>
                        <td class="text-right" style="font-weight:600;">
                            <fmt:formatNumber value="${booking.totalAmount}" type="number" groupingUsed="true" />đ
                        </td>
                    </tr>
                    <c:if test="${booking.discountAmount != null && booking.discountAmount > 0}">
                        <tr>
                            <td style="color:#059669;padding:.3rem 0;">Giảm giá:</td>
                            <td class="text-right" style="color:#059669;font-weight:600;">
                                -<fmt:formatNumber value="${booking.discountAmount}" type="number" groupingUsed="true" />đ
                            </td>
                        </tr>
                    </c:if>
                    <tr>
                        <td style="color:#64748b;padding:.3rem 0;">Đã thanh toán:</td>
                        <td class="text-right" style="font-weight:600;color:#059669;">
                            <fmt:formatNumber value="${booking.totalAmount - amountDue}" type="number" groupingUsed="true" />đ
                        </td>
                    </tr>
                    <tr style="border-top:2px solid #e2e8f0;">
                        <td style="padding:.5rem 0;font-size:1rem;font-weight:800;">CÒN LẠI:</td>
                        <td class="text-right" style="font-size:1.2rem;font-weight:800;color:${isFullyPaid ? '#059669' : '#dc2626'};">
                            <fmt:formatNumber value="${amountDue}" type="number" groupingUsed="true" />đ
                        </td>
                    </tr>
                </table>

                <%-- Payments list --%>
                <c:if test="${not empty payments}">
                    <div style="margin-top:1rem;">
                        <div style="font-size:.7rem;font-weight:700;text-transform:uppercase;letter-spacing:.07em;color:#64748b;margin-bottom:.5rem;">Lịch sử thanh toán</div>
                        <c:forEach var="p" items="${payments}">
                            <div style="display:flex;justify-content:space-between;font-size:.8rem;padding:.3rem 0;border-bottom:1px solid #f1f5f9;">
                                <span style="color:#64748b;">
                                    <fmt:formatDate value="${p.paidAt}" pattern="dd/MM HH:mm" /> &middot; ${p.method}
                                </span>
                                <span style="font-weight:600;color:#059669;">
                                    +<fmt:formatNumber value="${p.amount}" type="number" groupingUsed="true" />đ
                                </span>
                            </div>
                        </c:forEach>
                    </div>
                </c:if>
            </div>
        </div>
    </div>

    <%-- Footer note --%>
    <div style="margin-top:2rem;padding-top:1rem;border-top:1px solid #e2e8f0;text-align:center;font-size:.78rem;color:#94a3b8;">
        Cảm ơn quý khách đã tin tưởng sử dụng dịch vụ của Hotel Manager.<br>
        Mọi thắc mắc xin liên hệ: 028 1234 5678 | hotel@hotel.vn
    </div>

</div>

<script src="https://cdn.jsdelivr.net/npm/qrcode@1.5.3/build/qrcode.min.js"></script>
<script>
(function () {
    var qrEl = document.getElementById('qrcode');
    if (!qrEl) return;
    var amount = ${amountDue};
    var code = '${not empty booking.confirmationCode ? booking.confirmationCode : "BK".concat(booking.id)}';
    var qrText = 'MB|9704216220071437|TT ' + code + '|' + amount;
    if (typeof QRCode !== 'undefined') {
        new QRCode(qrEl, {
            text: qrText,
            width: 150,
            height: 150,
            colorDark: '#1e1b4b',
            colorLight: '#ffffff',
            correctLevel: QRCode.CorrectLevel.M
        });
    }
})();
</script>

<%@ include file="../layout/footer.jsp" %>
