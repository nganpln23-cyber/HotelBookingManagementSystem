<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Lịch đặt phòng" />
<%@ include file="../layout/header.jsp" %>

<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.11/index.global.min.css">

<div class="d-flex align-items-center justify-content-between mb-3" style="flex-wrap:wrap;gap:.5rem;">
    <div class="d-flex align-items-center" style="gap:.5rem;flex-wrap:wrap;">
        <span style="font-size:.78rem;font-weight:600;color:#64748b;">Lọc:</span>
        <button class="btn btn-xs cal-filter active" data-status="" style="font-size:.72rem;padding:.2rem .55rem;border-radius:999px;background:#4f46e5;color:#fff;border:none;">Tất cả</button>
        <button class="btn btn-xs cal-filter" data-status="PENDING"    style="font-size:.72rem;padding:.2rem .55rem;border-radius:999px;background:#fef3c7;color:#92400e;border:1px solid #f59e0b;">Chờ xác nhận</button>
        <button class="btn btn-xs cal-filter" data-status="CONFIRMED"  style="font-size:.72rem;padding:.2rem .55rem;border-radius:999px;background:#ede9fe;color:#5b21b6;border:1px solid #4f46e5;">Đã xác nhận</button>
        <button class="btn btn-xs cal-filter" data-status="CHECKED_IN" style="font-size:.72rem;padding:.2rem .55rem;border-radius:999px;background:#d1fae5;color:#065f46;border:1px solid #10b981;">Đang ở</button>
        <button class="btn btn-xs cal-filter" data-status="CHECKED_OUT" style="font-size:.72rem;padding:.2rem .55rem;border-radius:999px;background:#f1f5f9;color:#475569;border:1px solid #94a3b8;">Đã trả phòng</button>
        <button class="btn btn-xs cal-filter" data-status="CANCELLED"  style="font-size:.72rem;padding:.2rem .55rem;border-radius:999px;background:#fee2e2;color:#991b1b;border:1px solid #ef4444;">Đã hủy</button>
    </div>
    <div>
        <a href="${pageContext.request.contextPath}/admin/bookings" class="btn btn-outline-secondary btn-sm">
            <i class="fas fa-list"></i> Danh sách
        </a>
        <a href="${pageContext.request.contextPath}/admin/bookings/new" class="btn btn-primary btn-sm ml-1">
            <i class="fas fa-plus"></i> Tạo booking
        </a>
    </div>
</div>

<div class="card">
    <div class="card-body p-3">
        <div id="booking-calendar"></div>
    </div>
</div>

<%-- Booking detail modal --%>
<div class="modal fade" id="bookingModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content" style="border-radius:.75rem;border:1px solid #e2e8f0;">
            <div class="modal-header border-0 pb-0">
                <h5 class="modal-title" style="font-weight:800;">Chi tiết đặt phòng</h5>
                <button type="button" class="close" data-dismiss="modal">&times;</button>
            </div>
            <div class="modal-body">
                <div id="modal-content"></div>
            </div>
            <div class="modal-footer border-0 pt-0">
                <a id="modal-btn-bill" href="#" target="_blank" class="btn btn-dark btn-sm">
                    <i class="fas fa-print"></i> In hóa đơn
                </a>
                <a id="modal-btn-edit" href="#" class="btn btn-light btn-sm">
                    <i class="fas fa-pen"></i> Chỉnh sửa
                </a>
                <button type="button" class="btn btn-outline-secondary btn-sm" data-dismiss="modal">Đóng</button>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.11/index.global.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.11/locales/vi.global.min.js"></script>
<script>
document.addEventListener('DOMContentLoaded', function () {
    var ctx = '${pageContext.request.contextPath}';
    var allEvents = [];
    var activeFilter = '';

    var cal = new FullCalendar.Calendar(document.getElementById('booking-calendar'), {
        locale: 'vi',
        initialView: 'dayGridMonth',
        headerToolbar: { left: 'prev,next today', center: 'title', right: 'dayGridMonth,listMonth' },
        buttonText: { today: 'Hôm nay', month: 'Tháng', list: 'Danh sách' },
        events: function (info, successCb) {
            fetch(ctx + '/admin/bookings/calendar-events')
                .then(function (r) { return r.json(); })
                .then(function (data) {
                    allEvents = data;
                    successCb(activeFilter ? data.filter(function (e) { return e.status === activeFilter; }) : data);
                })
                .catch(function () { successCb([]); });
        },
        eventDisplay: 'block',
        dayMaxEvents: 3,
        eventContent: function (arg) {
            var p = arg.event.extendedProps;
            return {
                html: '<div style="padding:1px 4px;overflow:hidden;white-space:nowrap;text-overflow:ellipsis;font-size:.72rem;">' +
                      '<strong>P.' + (p.roomNumber || '?') + '</strong> ' + (p.customerName || '') + '</div>'
            };
        },
        eventClick: function (info) {
            info.jsEvent.preventDefault();
            var p = info.event.extendedProps;
            var fmt = function (n) { return n ? Number(n).toLocaleString('vi-VN') + 'đ' : '—'; };
            var statusLabel = {
                'PENDING':    '<span class="badge badge-status-PENDING">Chờ xác nhận</span>',
                'CONFIRMED':  '<span class="badge badge-status-CONFIRMED">Đã xác nhận</span>',
                'CHECKED_IN': '<span class="badge badge-status-CHECKED_IN">Đang ở</span>',
                'CHECKED_OUT':'<span class="badge badge-status-CHECKED_OUT">Đã trả phòng</span>',
                'CANCELLED':  '<span class="badge badge-status-CANCELLED">Đã hủy</span>'
            }[p.status] || p.status;
            var html = '<table class="table table-borderless mb-0" style="font-size:.875rem;">' +
                '<tr><th width="130" style="color:#64748b;font-weight:600;">Khách hàng</th><td style="font-weight:700;">' + (p.customerName||'—') + '</td></tr>' +
                '<tr><th>Phòng</th><td><strong>' + (p.roomNumber||'—') + '</strong>' + (p.roomTypeName ? ' &middot; '+p.roomTypeName : '') + '</td></tr>' +
                '<tr><th>Nhận phòng</th><td>' + info.event.startStr + '</td></tr>' +
                '<tr><th>Trả phòng</th><td>' + (info.event.endStr||'') + '</td></tr>' +
                '<tr><th>Trạng thái</th><td>' + statusLabel + '</td></tr>' +
                '<tr><th>Tổng tiền</th><td><strong style="color:#4f46e5;">' + fmt(p.totalAmount) + '</strong></td></tr>';
            if (p.confirmationCode) html += '<tr><th>Mã đặt</th><td><span class="code-chip code-confirm"><i class="fas fa-barcode" style="font-size:.65rem;"></i>' + p.confirmationCode + '</span></td></tr>';
            html += '</table>';
            document.getElementById('modal-content').innerHTML = html;
            document.getElementById('modal-btn-bill').href = ctx + '/admin/bookings/invoice/' + p.bookingId;
            document.getElementById('modal-btn-edit').href = ctx + '/admin/bookings/edit/' + p.bookingId;
            $('#bookingModal').modal('show');
        },
        eventDidMount: function (info) {
            info.el.title = (info.event.extendedProps.roomNumber || '') + ' - ' + (info.event.extendedProps.customerName || '');
        }
    });

    cal.render();

    // Filter buttons
    document.querySelectorAll('.cal-filter').forEach(function (btn) {
        btn.addEventListener('click', function () {
            document.querySelectorAll('.cal-filter').forEach(function (b) { b.style.fontWeight = ''; b.style.boxShadow = ''; });
            this.style.fontWeight = '700';
            this.style.boxShadow = '0 0 0 2px rgba(79,70,229,.4)';
            activeFilter = this.dataset.status;
            cal.refetchEvents();
        });
    });
});
</script>

<%@ include file="../layout/footer.jsp" %>
