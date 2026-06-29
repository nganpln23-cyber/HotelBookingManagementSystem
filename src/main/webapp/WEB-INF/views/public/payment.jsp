<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Thanh toán đặt phòng" />
<c:set var="solidNav" value="true" />
<%@ include file="../layout/public-header.jsp" %>

<style>
.pay-hero { background:linear-gradient(135deg,#0f172a 0%,#1e293b 100%); padding:2.5rem 0 3rem; }
.pay-steps { display:flex; align-items:center; gap:0; margin-bottom:0; }
.pay-step { display:flex; align-items:center; gap:.5rem; font-size:.82rem; font-weight:600; color:rgba(255,255,255,.4); }
.pay-step.done { color:#10b981; }
.pay-step.active { color:#fff; }
.pay-step-num { width:26px; height:26px; border-radius:50%; display:flex; align-items:center; justify-content:center; font-size:.75rem; font-weight:700; background:rgba(255,255,255,.1); }
.pay-step.done .pay-step-num { background:#10b981; color:#fff; }
.pay-step.active .pay-step-num { background:var(--ph-gold); color:#0f172a; }
.pay-step-sep { width:40px; height:1px; background:rgba(255,255,255,.15); margin:0 .5rem; }
.pay-wrap { background:#f1f5f9; padding:2.5rem 0 4rem; }
.pay-card { background:#fff; border-radius:12px; box-shadow:0 2px 16px rgba(0,0,0,.06); overflow:hidden; }
.pay-card-head { padding:1.1rem 1.5rem; border-bottom:1px solid #f1f5f9; font-size:.9rem; font-weight:700; color:#0f172a; }
.pay-card-body { padding:1.5rem; }
.summary-row { display:flex; justify-content:space-between; align-items:center; padding:.5rem 0; font-size:.88rem; border-bottom:1px solid #f1f5f9; }
.summary-row:last-child { border:none; }
.summary-row.total { font-weight:700; font-size:1rem; color:#0f172a; padding-top:.75rem; }
.summary-label { color:#64748b; }
/* Card Visual */
.cc-card { width:100%; max-width:340px; height:190px; border-radius:16px; padding:22px 24px; background:linear-gradient(135deg,#1e293b 0%,#0f172a 50%,#1e3a5f 100%); color:#fff; position:relative; overflow:hidden; margin:0 auto 1.75rem; box-shadow:0 12px 40px rgba(0,0,0,.25); }
.cc-card::before { content:''; position:absolute; top:-40px; right:-40px; width:180px; height:180px; border-radius:50%; background:rgba(255,255,255,.04); }
.cc-card::after { content:''; position:absolute; bottom:-60px; right:40px; width:140px; height:140px; border-radius:50%; background:rgba(255,255,255,.03); }
.cc-chip { width:38px; height:28px; background:linear-gradient(135deg,#d4af37,#f5c842); border-radius:4px; margin-bottom:20px; display:flex; align-items:center; justify-content:center; }
.cc-chip-lines { display:grid; grid-template-columns:1fr 1fr; gap:3px; width:24px; }
.cc-chip-line { height:3px; background:rgba(0,0,0,.3); border-radius:2px; }
.cc-number { font-size:1.05rem; letter-spacing:3px; font-family:monospace; margin-bottom:18px; opacity:.95; word-spacing:8px; }
.cc-bottom { display:flex; justify-content:space-between; align-items:flex-end; }
.cc-label { font-size:.55rem; text-transform:uppercase; letter-spacing:.08em; opacity:.6; margin-bottom:3px; }
.cc-value { font-size:.8rem; font-weight:600; letter-spacing:.5px; }
.cc-brand { font-size:1.2rem; font-weight:800; font-style:italic; opacity:.7; }
/* Form */
.pay-input-group { margin-bottom:1.1rem; }
.pay-label { font-size:.8rem; font-weight:600; color:#374151; display:block; margin-bottom:.4rem; }
.pay-input { width:100%; padding:.65rem .9rem; border:1.5px solid #e2e8f0; border-radius:8px; font-size:.9rem; transition:border-color .2s; outline:none; background:#fff; }
.pay-input:focus { border-color:var(--ph-gold); box-shadow:0 0 0 3px rgba(185,143,73,.12); }
.pay-input.error { border-color:#ef4444; }
.pay-btn { width:100%; padding:.85rem; background:linear-gradient(135deg,#b98f49,#d4af37); color:#0f172a; border:none; border-radius:10px; font-size:1rem; font-weight:700; cursor:pointer; display:flex; align-items:center; justify-content:center; gap:.6rem; transition:all .2s; margin-top:1.25rem; }
.pay-btn:hover { transform:translateY(-1px); box-shadow:0 6px 20px rgba(185,143,73,.35); }
.pay-btn:active { transform:translateY(0); }
.pay-btn:disabled { opacity:.7; cursor:not-allowed; transform:none; }
.pay-spinner { width:18px; height:18px; border:2px solid rgba(15,23,42,.3); border-top-color:#0f172a; border-radius:50%; animation:spin .7s linear infinite; display:none; }
@keyframes spin { to { transform:rotate(360deg); } }
.card-logos { display:flex; gap:.5rem; flex-wrap:wrap; margin-top:1rem; }
.card-logo { padding:.25rem .6rem; border:1px solid #e2e8f0; border-radius:5px; font-size:.65rem; font-weight:700; color:#64748b; background:#f8fafc; }
.secure-badge { display:flex; align-items:center; gap:.4rem; font-size:.75rem; color:#64748b; margin-top:.75rem; }
.cancel-link { display:block; text-align:center; margin-top:1rem; font-size:.82rem; color:#94a3b8; text-decoration:none; }
.cancel-link:hover { color:#64748b; }
</style>

<div class="pay-hero">
    <div class="container">
        <div class="ph-breadcrumb" style="margin-bottom:1.25rem;">
            <a href="${pageContext.request.contextPath}/" style="color:rgba(255,255,255,.5);">Trang chủ</a>
            <span style="color:rgba(255,255,255,.3);">&rsaquo;</span>
            <a href="${pageContext.request.contextPath}/rooms" style="color:rgba(255,255,255,.5);">Phòng</a>
            <span style="color:rgba(255,255,255,.3);">&rsaquo;</span>
            <span style="color:rgba(255,255,255,.7);">Thanh toán</span>
        </div>
        <div class="pay-steps">
            <div class="pay-step done">
                <div class="pay-step-num"><i class="fas fa-check" style="font-size:.6rem;"></i></div>
                <span>Đặt phòng</span>
            </div>
            <div class="pay-step-sep"></div>
            <div class="pay-step active">
                <div class="pay-step-num">2</div>
                <span>Thanh toán</span>
            </div>
            <div class="pay-step-sep"></div>
            <div class="pay-step">
                <div class="pay-step-num">3</div>
                <span>Xác nhận</span>
            </div>
        </div>
    </div>
</div>

<div class="pay-wrap">
    <div class="container">
        <div class="row">

            <%-- Left: booking summary --%>
            <div class="col-lg-5 mb-4">
                <div class="pay-card">
                    <div class="pay-card-head"><i class="fas fa-receipt mr-2" style="color:var(--ph-gold);"></i>Tóm tắt đặt phòng</div>
                    <div class="pay-card-body">
                        <div style="background:linear-gradient(135deg,#0f172a,#1e3a5f);border-radius:10px;padding:1.1rem 1.25rem;color:#fff;margin-bottom:1.25rem;">
                            <div style="font-size:.65rem;text-transform:uppercase;letter-spacing:.1em;color:var(--ph-gold);margin-bottom:.3rem;">${booking.roomTypeName}</div>
                            <div style="font-size:1.15rem;font-weight:700;">Phòng ${booking.roomNumber}</div>
                        </div>
                        <div class="summary-row">
                            <span class="summary-label"><i class="fas fa-sign-in-alt mr-1"></i>Nhận phòng</span>
                            <strong>${booking.checkInDate}</strong>
                        </div>
                        <div class="summary-row">
                            <span class="summary-label"><i class="fas fa-sign-out-alt mr-1"></i>Trả phòng</span>
                            <strong>${booking.checkOutDate}</strong>
                        </div>
                        <div class="summary-row">
                            <span class="summary-label"><i class="fas fa-moon mr-1"></i>Số đêm</span>
                            <strong>${nights} đêm</strong>
                        </div>
                        <c:if test="${booking.discountAmount != null && booking.discountAmount > 0}">
                        <div class="summary-row">
                            <span class="summary-label">Giảm giá (<c:out value="${booking.promoCode}"/>)</span>
                            <span style="color:#10b981;">-<fmt:formatNumber value="${booking.discountAmount}" type="number" groupingUsed="true"/>đ</span>
                        </div>
                        </c:if>
                        <div class="summary-row total">
                            <span>Tổng thanh toán</span>
                            <span style="color:var(--ph-gold);font-size:1.15rem;"><fmt:formatNumber value="${booking.totalAmount}" type="number" groupingUsed="true"/>đ</span>
                        </div>
                        <div class="secure-badge mt-3">
                            <i class="fas fa-shield-alt" style="color:#10b981;"></i>
                            Thanh toán bảo mật SSL 256-bit — thông tin thẻ không được lưu trữ
                        </div>
                    </div>
                </div>
            </div>

            <%-- Right: payment form --%>
            <div class="col-lg-7">
                <div class="pay-card">
                    <div class="pay-card-head"><i class="fas fa-credit-card mr-2" style="color:var(--ph-gold);"></i>Thông tin thanh toán</div>
                    <div class="pay-card-body">

                        <%-- Live card preview --%>
                        <div class="cc-card" id="ccPreview">
                            <div class="cc-chip">
                                <div class="cc-chip-lines">
                                    <div class="cc-chip-line"></div><div class="cc-chip-line"></div>
                                    <div class="cc-chip-line"></div><div class="cc-chip-line"></div>
                                </div>
                            </div>
                            <div class="cc-number" id="ccNum">•••• •••• •••• ••••</div>
                            <div class="cc-bottom">
                                <div>
                                    <div class="cc-label">Chủ thẻ</div>
                                    <div class="cc-value" id="ccName">TÊN CHỦ THẺ</div>
                                </div>
                                <div>
                                    <div class="cc-label">Hết hạn</div>
                                    <div class="cc-value" id="ccExp">MM/YY</div>
                                </div>
                                <div class="cc-brand" id="ccBrand">VISA</div>
                            </div>
                        </div>

                        <form id="paymentForm" method="post" action="${pageContext.request.contextPath}/booking/payment/${booking.id}/process" onsubmit="return handlePay(event)">

                            <div class="pay-input-group">
                                <label class="pay-label">Số thẻ <span style="color:#ef4444;">*</span></label>
                                <input class="pay-input" id="cardNumber" name="cardNumber" type="text" maxlength="19"
                                       placeholder="1234 5678 9012 3456" autocomplete="cc-number" required>
                            </div>

                            <div class="pay-input-group">
                                <label class="pay-label">Tên chủ thẻ <span style="color:#ef4444;">*</span></label>
                                <input class="pay-input" id="cardName" name="cardName" type="text"
                                       placeholder="NGUYEN VAN A" autocomplete="cc-name" required
                                       style="text-transform:uppercase;">
                            </div>

                            <div class="row" style="margin:0 -6px;">
                                <div class="col-6" style="padding:0 6px;">
                                    <div class="pay-input-group">
                                        <label class="pay-label">Ngày hết hạn <span style="color:#ef4444;">*</span></label>
                                        <input class="pay-input" id="cardExp" name="cardExp" type="text"
                                               placeholder="MM/YY" maxlength="5" autocomplete="cc-exp" required>
                                    </div>
                                </div>
                                <div class="col-6" style="padding:0 6px;">
                                    <div class="pay-input-group">
                                        <label class="pay-label">CVV <span style="color:#ef4444;">*</span></label>
                                        <input class="pay-input" id="cardCvv" name="cardCvv" type="password"
                                               placeholder="•••" maxlength="4" autocomplete="cc-csc" required>
                                    </div>
                                </div>
                            </div>

                            <button type="submit" class="pay-btn" id="payBtn">
                                <span class="pay-spinner" id="paySpinner"></span>
                                <i class="fas fa-lock" id="payIcon"></i>
                                <span id="payText">Thanh toán <fmt:formatNumber value="${booking.totalAmount}" type="number" groupingUsed="true"/>đ</span>
                            </button>

                            <div class="card-logos">
                                <span class="card-logo">VISA</span>
                                <span class="card-logo">MASTERCARD</span>
                                <span class="card-logo">JCB</span>
                                <span class="card-logo">NAPAS</span>
                                <span class="card-logo">MOMO</span>
                            </div>
                        </form>

                        <a href="${pageContext.request.contextPath}/booking/cancel-payment/${booking.id}" class="cancel-link"
                           onclick="return confirm('Hủy đặt phòng này và quay lại trang phòng?')">
                            <i class="fas fa-times mr-1"></i>Hủy và quay lại
                        </a>

                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
// Live card preview
const numEl = document.getElementById('ccNum');
const nameEl = document.getElementById('ccName');
const expEl = document.getElementById('ccExp');
const brandEl = document.getElementById('ccBrand');

document.getElementById('cardNumber').addEventListener('input', function(e) {
    var v = this.value.replace(/\D/g,'').substring(0,16);
    var parts = v.match(/.{1,4}/g) || [];
    this.value = parts.join(' ');
    var display = (v + '????????????????').substring(0,16).match(/.{1,4}/g).join(' ');
    numEl.textContent = display;
    brandEl.textContent = v[0]==='4' ? 'VISA' : v[0]==='5' ? 'MC' : v.substring(0,2)==='35' ? 'JCB' : 'CARD';
});

document.getElementById('cardName').addEventListener('input', function() {
    nameEl.textContent = (this.value.toUpperCase() || 'TÊN CHỦ THẺ').substring(0,22);
});

document.getElementById('cardExp').addEventListener('input', function(e) {
    var v = this.value.replace(/\D/g,'');
    if (v.length >= 2) v = v.substring(0,2) + '/' + v.substring(2,4);
    this.value = v;
    expEl.textContent = this.value || 'MM/YY';
});

function handlePay(e) {
    e.preventDefault();
    var btn = document.getElementById('payBtn');
    var spinner = document.getElementById('paySpinner');
    var icon = document.getElementById('payIcon');
    var text = document.getElementById('payText');
    btn.disabled = true;
    spinner.style.display = 'block';
    icon.style.display = 'none';
    text.textContent = 'Đang xử lý...';
    setTimeout(function() { document.getElementById('paymentForm').submit(); }, 1800);
    return false;
}
</script>

<%@ include file="../layout/public-footer.jsp" %>
