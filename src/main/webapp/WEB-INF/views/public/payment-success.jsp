<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Đặt phòng thành công" />
<c:set var="solidNav" value="true" />
<%@ include file="../layout/public-header.jsp" %>

<style>
.success-wrap { background:#f1f5f9; padding:4rem 0 5rem; }
.success-card { background:#fff; border-radius:16px; box-shadow:0 4px 32px rgba(0,0,0,.08); max-width:620px; margin:0 auto; overflow:hidden; }
.success-header { background:linear-gradient(135deg,#0f172a,#1e3a5f); padding:3rem 2rem; text-align:center; }
.success-check { width:72px; height:72px; border-radius:50%; background:linear-gradient(135deg,#10b981,#059669); display:flex; align-items:center; justify-content:center; margin:0 auto 1.25rem; animation:popIn .5s cubic-bezier(.36,.07,.19,.97) both; }
@keyframes popIn { from { transform:scale(0); opacity:0; } to { transform:scale(1); opacity:1; } }
.success-title { color:#fff; font-size:1.5rem; font-weight:700; margin-bottom:.5rem; }
.success-sub { color:rgba(255,255,255,.65); font-size:.88rem; }
.success-body { padding:2rem 2.25rem; }
.detail-row { display:flex; justify-content:space-between; padding:.65rem 0; border-bottom:1px solid #f1f5f9; font-size:.9rem; }
.detail-row:last-child { border:none; }
.detail-label { color:#64748b; }
.detail-val { font-weight:600; color:#0f172a; }
.status-badge { display:inline-flex; align-items:center; gap:.4rem; padding:.3rem .75rem; border-radius:20px; font-size:.78rem; font-weight:700; }
.badge-pending { background:#fef3c7; color:#92400e; }
.email-notice { background:#ecfdf5; border:1px solid #a7f3d0; border-radius:10px; padding:1rem 1.25rem; margin:1.25rem 0; display:flex; gap:.75rem; align-items:flex-start; }
.email-notice-icon { color:#10b981; font-size:1.1rem; flex-shrink:0; margin-top:.1rem; }
.txn-box { background:#f8fafc; border:1px solid #e2e8f0; border-radius:8px; padding:.75rem 1rem; margin-bottom:1.25rem; display:flex; justify-content:space-between; align-items:center; }
.txn-label { font-size:.78rem; color:#64748b; }
.txn-val { font-family:monospace; font-size:.82rem; font-weight:700; color:#0f172a; letter-spacing:.5px; }
.action-btns { display:flex; gap:.75rem; flex-wrap:wrap; margin-top:1.5rem; }
.btn-home { flex:1; text-align:center; padding:.75rem; border-radius:10px; font-weight:700; font-size:.9rem; background:linear-gradient(135deg,#b98f49,#d4af37); color:#0f172a; text-decoration:none; }
.btn-home:hover { color:#0f172a; opacity:.9; }
.btn-account { flex:1; text-align:center; padding:.75rem; border-radius:10px; font-weight:700; font-size:.9rem; border:1.5px solid #e2e8f0; color:#374151; text-decoration:none; background:#fff; }
.btn-account:hover { background:#f8fafc; color:#374151; }
</style>

<div class="success-wrap">
    <div class="container">
        <div class="success-card">
            <div class="success-header">
                <div class="success-check">
                    <i class="fas fa-check" style="color:#fff;font-size:1.75rem;"></i>
                </div>
                <div class="success-title">Thanh toán thành công!</div>
                <div class="success-sub">Cảm ơn bạn đã đặt phòng tại Grand Beach Hotel</div>
            </div>

            <div class="success-body">

                <c:if test="${not empty booking.onlinePaymentRef}">
                <div class="txn-box">
                    <span class="txn-label">Mã giao dịch</span>
                    <span class="txn-val">${booking.onlinePaymentRef}</span>
                </div>
                </c:if>

                <div class="detail-row">
                    <span class="detail-label">Phòng</span>
                    <span class="detail-val">Phòng ${booking.roomNumber} &mdash; ${booking.roomTypeName}</span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Nhận phòng</span>
                    <span class="detail-val">${booking.checkInDate}</span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Trả phòng</span>
                    <span class="detail-val">${booking.checkOutDate} &nbsp;(${nights} đêm)</span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Số tiền đã thanh toán</span>
                    <span class="detail-val" style="color:var(--ph-gold);font-size:1.05rem;">
                        <fmt:formatNumber value="${booking.totalAmount}" type="number" groupingUsed="true"/>đ
                    </span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Trạng thái đặt phòng</span>
                    <span class="status-badge badge-pending"><i class="fas fa-clock"></i>Chờ xác nhận</span>
                </div>

                <div class="email-notice">
                    <div class="email-notice-icon"><i class="fas fa-envelope-open-text"></i></div>
                    <div style="font-size:.85rem;color:#065f46;line-height:1.6;">
                        <strong>Email xác nhận sẽ được gửi cho bạn.</strong><br>
                        <c:choose>
                            <c:when test="${not empty booking.customerEmail}">
                                Chúng tôi đã nhận được thanh toán và sẽ xác nhận đặt phòng của bạn trong vòng <strong>30 phút</strong>.
                                Email xác nhận sẽ được gửi đến <strong>${booking.customerEmail}</strong>.
                            </c:when>
                            <c:otherwise>
                                Chúng tôi đã nhận được thanh toán và sẽ xác nhận đặt phòng của bạn trong vòng <strong>30 phút</strong>.
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <div class="action-btns">
                    <a href="${pageContext.request.contextPath}/" class="btn-home">
                        <i class="fas fa-home mr-1"></i>Về trang chủ
                    </a>
                    <c:if test="${not empty sessionScope.currentCustomer}">
                    <a href="${pageContext.request.contextPath}/account" class="btn-account">
                        <i class="fas fa-history mr-1"></i>Lịch sử đặt phòng
                    </a>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="../layout/public-footer.jsp" %>
