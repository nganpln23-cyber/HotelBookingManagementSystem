<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Tài khoản của tôi" />
<c:set var="solidNav" value="true" />
<%@ include file="../layout/public-header.jsp" %>

<%-- DASHBOARD HERO --%>
<div class="ph-dash-hero">
    <div class="container">
        <div class="ph-breadcrumb">
            <a href="${pageContext.request.contextPath}/">Trang chủ</a>
            <span>&rsaquo;</span> Tài khoản
        </div>
        <h2>Xin chào, ${customer.fullName}</h2>
        <p>Quản lý lịch sử đặt phòng, hóa đơn và ưu đãi của bạn</p>
    </div>
</div>

<div style="background:var(--ph-bg);padding:0 0 4rem;">
    <div class="container">
        <%-- STAT CARDS (overlap hero) --%>
        <div class="row" style="margin-top:-1.5rem;margin-bottom:2.5rem;">
            <div class="col-md-4 mb-3">
                <div class="ph-dash-stat">
                    <div class="ph-dash-icon gold"><i class="fas fa-calendar-check"></i></div>
                    <div>
                        <div class="ph-dash-stat-num">${bookings.size()}</div>
                        <div class="ph-dash-stat-label">Tổng lượt đặt phòng</div>
                    </div>
                </div>
            </div>
            <div class="col-md-4 mb-3">
                <div class="ph-dash-stat">
                    <div class="ph-dash-icon navy"><i class="fas fa-envelope"></i></div>
                    <div>
                        <div class="ph-dash-stat-num" style="font-size:1rem;font-family:Inter,sans-serif;font-weight:600;">${customer.email}</div>
                        <div class="ph-dash-stat-label">${customer.phone}</div>
                    </div>
                </div>
            </div>
            <div class="col-md-4 mb-3">
                <div class="ph-dash-stat">
                    <div class="ph-dash-icon green"><i class="fas fa-gift"></i></div>
                    <div>
                        <div class="ph-dash-stat-num">${promotions.size()}</div>
                        <div class="ph-dash-stat-label">Mã ưu đãi khả dụng</div>
                    </div>
                </div>
            </div>
        </div>

        <%-- PROMOTIONS --%>
        <c:if test="${not empty promotions}">
        <div class="ph-table-card mb-4">
            <div class="card-head"><i class="fas fa-gift"></i>Ưu đãi dành riêng cho bạn</div>
            <div style="padding:1.5rem;">
                <div class="row">
                    <c:forEach var="promo" items="${promotions}">
                        <div class="col-md-6 col-lg-4 mb-3">
                            <div class="ph-promo-chip">
                                <div>
                                    <div class="ph-promo-code">${promo.code}</div>
                                    <div style="font-size:.78rem;color:var(--ph-muted);margin-top:.15rem;">${promo.description}</div>
                                </div>
                                <span class="ph-promo-pct">-${promo.discountPercent}%</span>
                            </div>
                        </div>
                    </c:forEach>
                </div>
                <p style="font-size:.8rem;color:var(--ph-muted);margin:0;margin-top:.5rem;">
                    <i class="fas fa-info-circle mr-1" style="color:var(--ph-gold);"></i>
                    Nhập mã ưu đãi ở bước đặt phòng để áp dụng giảm giá.
                </p>
            </div>
        </div>
        </c:if>

        <%-- BOOKING HISTORY --%>
        <div class="ph-table-card">
            <div class="card-head d-flex justify-content-between align-items-center">
                <span><i class="fas fa-receipt"></i>Lịch sử đặt phòng</span>
                <a href="${pageContext.request.contextPath}/booking/new"
                   style="background:var(--ph-gold);color:var(--ph-dark);font-weight:700;font-size:.78rem;padding:.4rem .9rem;border-radius:4px;text-decoration:none;">
                   <i class="fas fa-plus mr-1"></i>Đặt phòng mới
                </a>
            </div>
            <div class="table-responsive">
                <table class="ph-table">
                    <thead>
                        <tr>
                            <th>Mã</th>
                            <th>Phòng</th>
                            <th>Nhận phòng</th>
                            <th>Trả phòng</th>
                            <th>Trạng thái</th>
                            <th>Tổng tiền</th>
                            <th>Giảm giá</th>
                            <th></th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="b" items="${bookings}">
                            <tr>
                                <td style="font-weight:600;color:var(--ph-dark);">#${b.id}</td>
                                <td>
                                    <div style="font-weight:600;color:var(--ph-dark);">${b.roomNumber}</div>
                                    <div style="font-size:.78rem;color:var(--ph-muted);">${b.roomTypeName}</div>
                                </td>
                                <td>${b.checkInDate}</td>
                                <td>${b.checkOutDate}</td>
                                <td><span class="status-badge status-${b.status}">${b.status}</span></td>
                                <td style="font-weight:600;">
                                    <fmt:formatNumber value="${b.totalAmount}" type="number" groupingUsed="true"/>
                                    <span style="font-size:.75rem;color:var(--ph-muted);">VND</span>
                                </td>
                                <td>
                                    <c:if test="${b.discountAmount > 0}">
                                        <span style="color:#065f46;font-weight:600;">
                                            -<fmt:formatNumber value="${b.discountAmount}" type="number" groupingUsed="true"/> VND
                                        </span>
                                        <div style="font-size:.72rem;color:var(--ph-muted);">${b.promoCode}</div>
                                    </c:if>
                                    <c:if test="${b.discountAmount == 0}">—</c:if>
                                </td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/account/bookings/${b.id}"
                                       class="btn btn-outline-primary btn-sm" style="font-size:.78rem;white-space:nowrap;">
                                       Chi tiết <i class="fas fa-chevron-right" style="font-size:.65rem;"></i>
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty bookings}">
                            <tr>
                                <td colspan="8" style="text-align:center;padding:3rem;color:var(--ph-muted);">
                                    <i class="fas fa-calendar-times" style="font-size:2rem;color:var(--ph-border);display:block;margin-bottom:.75rem;"></i>
                                    Bạn chưa có lượt đặt phòng nào.
                                    <br><a href="${pageContext.request.contextPath}/booking/new" style="color:var(--ph-gold);font-weight:600;margin-top:.5rem;display:inline-block;">Đặt phòng ngay</a>
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>

        <div style="margin-top:1.5rem;text-align:center;">
            <a href="${pageContext.request.contextPath}/account/logout"
               style="font-size:.85rem;color:var(--ph-muted);text-decoration:none;">
               <i class="fas fa-sign-out-alt mr-1"></i>Đăng xuất tài khoản
            </a>
        </div>
    </div>
</div>

<%@ include file="../layout/public-footer.jsp" %>
