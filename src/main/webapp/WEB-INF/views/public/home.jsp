<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Trang chủ" />
<%@ include file="../layout/public-header.jsp" %>

<%-- ═══ HERO ═══ --%>
<section class="ph-hero">
    <div class="ph-hero-content w-100">
        <span class="ph-hero-eyebrow">Chào mừng đến với Grand Beach Hotel</span>
        <h1>Kỳ nghỉ hoàn hảo<br><em>bên làn sóng biển</em></h1>
        <p>Thức dậy cùng tiếng sóng vỗ, tận hưởng bình minh trên biển và dịch vụ 5 sao giữa thiên nhiên nhiệt đới tuyệt vời.</p>

        <div class="ph-search-card">
            <form action="${pageContext.request.contextPath}/rooms" method="get">
                <div class="row align-items-end" style="gap:0;">
                    <div class="col-md-3 mb-3 mb-md-0">
                        <label><i class="fas fa-calendar-day mr-1"></i>Ngày nhận phòng</label>
                        <input type="text" class="form-control" id="heroCheckIn" name="checkIn" placeholder="Chọn ngày" autocomplete="off" required>
                    </div>
                    <div class="col-md-3 mb-3 mb-md-0">
                        <label><i class="fas fa-calendar-check mr-1"></i>Ngày trả phòng</label>
                        <input type="text" class="form-control" id="heroCheckOut" name="checkOut" placeholder="Chọn ngày" autocomplete="off" required>
                    </div>
                    <div class="col-md-3 mb-3 mb-md-0">
                        <label><i class="fas fa-layer-group mr-1"></i>Loại phòng</label>
                        <select class="form-control" name="roomTypeId">
                            <option value="">Tất cả loại phòng</option>
                            <c:forEach var="rt" items="${roomTypes}">
                                <option value="${rt.id}">${rt.typeName}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-3 mb-0">
                        <button type="submit" class="btn-ph-search">
                            <i class="fas fa-search"></i> Tìm phòng trống
                        </button>
                    </div>
                </div>
            </form>
        </div>
    </div>
</section>

<%-- ═══ STATS BAR ═══ --%>
<section class="ph-stats-bar">
    <div class="container">
        <div class="row text-center">
            <div class="col-6 col-md-3">
                <div class="ph-stat-item">
                    <span class="ph-stat-num">50+</span>
                    <span class="ph-stat-label">Phòng nghỉ</span>
                </div>
            </div>
            <div class="col-6 col-md-3">
                <div class="ph-stat-item">
                    <span class="ph-stat-num">10</span>
                    <span class="ph-stat-label">Năm kinh nghiệm</span>
                </div>
            </div>
            <div class="col-6 col-md-3 mt-3 mt-md-0">
                <div class="ph-stat-item">
                    <span class="ph-stat-num">4.9</span>
                    <span class="ph-stat-label">Đánh giá trung bình</span>
                </div>
            </div>
            <div class="col-6 col-md-3 mt-3 mt-md-0">
                <div class="ph-stat-item">
                    <span class="ph-stat-num">5K+</span>
                    <span class="ph-stat-label">Khách hài lòng</span>
                </div>
            </div>
        </div>
    </div>
</section>

<%-- ═══ ABOUT ═══ --%>
<section class="ph-section">
    <div class="container">
        <div class="row align-items-center">
            <div class="col-lg-6 mb-5 mb-lg-0">
                <div style="position:relative; display:inline-block; width:100%;">
                    <img src="https://images.unsplash.com/photo-1571896349842-33c89424de2d?w=900&q=80"
                         class="ph-about-img" alt="Grand Beach Hotel">
                    <div style="position:absolute;bottom:-18px;right:-18px;width:140px;height:140px;border:3px solid var(--ph-gold);border-radius:6px;z-index:-1;"></div>
                </div>
            </div>
            <div class="col-lg-6 pl-lg-5">
                <span class="ph-eyebrow">Về chúng tôi</span>
                <h2 class="ph-title">Nghỉ dưỡng đẳng cấp<br>bên bờ biển xanh</h2>
                <p class="ph-subtitle">
                    Tọa lạc ngay mép biển, Grand Beach Hotel mang đến tầm nhìn đại dương bao la,
                    làn gió trong lành và dịch vụ 5 sao. Mỗi kỳ nghỉ là một trải nghiệm thiên đường nhiệt đới.
                </p>
                <ul class="ph-check-list">
                    <li><span class="check-icon"><i class="fas fa-check"></i></span>Nhận &amp; trả phòng linh hoạt 24/7</li>
                    <li><span class="check-icon"><i class="fas fa-check"></i></span>Đặt phòng trực tuyến xác nhận tức thì</li>
                    <li><span class="check-icon"><i class="fas fa-check"></i></span>Giá tốt nhất, không phát sinh phụ phí ẩn</li>
                    <li><span class="check-icon"><i class="fas fa-check"></i></span>Hỗ trợ khách hàng 24/7, đa ngôn ngữ</li>
                </ul>
                <a href="${pageContext.request.contextPath}/rooms" class="btn-room-book" style="display:inline-flex;">
                    <i class="fas fa-door-open"></i> Khám phá phòng
                </a>
            </div>
        </div>
    </div>
</section>

<%-- ═══ AMENITIES ═══ --%>
<section class="ph-section-alt">
    <div class="container">
        <div class="text-center mb-5">
            <span class="ph-eyebrow">Tiện ích</span>
            <h2 class="ph-title">Trải nghiệm dịch vụ<br>đẳng cấp 5 sao</h2>
        </div>
        <div class="row">
            <div class="col-6 col-md-3 mb-4">
                <div class="ph-amenity">
                    <div class="ph-amenity-icon"><i class="fas fa-wifi"></i></div>
                    <h6>Wifi Tốc Độ Cao</h6>
                    <p>Kết nối miễn phí toàn khu vực khách sạn</p>
                </div>
            </div>
            <div class="col-6 col-md-3 mb-4">
                <div class="ph-amenity">
                    <div class="ph-amenity-icon"><i class="fas fa-swimming-pool"></i></div>
                    <h6>Hồ Bơi Vô Cực</h6>
                    <p>Hồ bơi ngoài trời view thành phố tuyệt đẹp</p>
                </div>
            </div>
            <div class="col-6 col-md-3 mb-4">
                <div class="ph-amenity">
                    <div class="ph-amenity-icon"><i class="fas fa-spa"></i></div>
                    <h6>Spa &amp; Wellness</h6>
                    <p>Trung tâm chăm sóc sức khỏe cao cấp</p>
                </div>
            </div>
            <div class="col-6 col-md-3 mb-4">
                <div class="ph-amenity">
                    <div class="ph-amenity-icon"><i class="fas fa-utensils"></i></div>
                    <h6>Nhà Hàng 5 Sao</h6>
                    <p>Ẩm thực đa dạng, phục vụ tận phòng 24/7</p>
                </div>
            </div>
            <div class="col-6 col-md-3 mb-4 mb-md-0">
                <div class="ph-amenity">
                    <div class="ph-amenity-icon"><i class="fas fa-dumbbell"></i></div>
                    <h6>Phòng Gym</h6>
                    <p>Trang thiết bị hiện đại, mở cửa mọi giờ</p>
                </div>
            </div>
            <div class="col-6 col-md-3 mb-4 mb-md-0">
                <div class="ph-amenity">
                    <div class="ph-amenity-icon"><i class="fas fa-parking"></i></div>
                    <h6>Bãi Đỗ Xe</h6>
                    <p>Miễn phí, an ninh 24/7 cho khách lưu trú</p>
                </div>
            </div>
            <div class="col-6 col-md-3">
                <div class="ph-amenity">
                    <div class="ph-amenity-icon"><i class="fas fa-shuttle-van"></i></div>
                    <h6>Đưa Đón Sân Bay</h6>
                    <p>Xe sang đón khách theo lịch bay</p>
                </div>
            </div>
            <div class="col-6 col-md-3">
                <div class="ph-amenity">
                    <div class="ph-amenity-icon"><i class="fas fa-concierge-bell"></i></div>
                    <h6>Concierge 24/7</h6>
                    <p>Hỗ trợ tour, vé, đặt bàn nhà hàng</p>
                </div>
            </div>
        </div>
    </div>
</section>

<%-- ═══ ROOM TYPES ═══ --%>
<section class="ph-section">
    <div class="container">
        <div class="text-center mb-5">
            <span class="ph-eyebrow">Hạng phòng</span>
            <h2 class="ph-title">Không gian nghỉ dưỡng<br>dành cho bạn</h2>
        </div>
        <div class="row">
            <c:forEach var="rt" items="${roomTypes}">
                <div class="col-md-6 col-lg-4 mb-4 d-flex">
                    <div class="ph-room-card w-100">
                        <div class="ph-room-img-wrap">
                            <img src="${rt.getImageDisplayUrl(pageContext.request.contextPath)}"
                                 class="ph-room-img" alt="${rt.typeName}">
                            <span class="ph-room-badge">${rt.typeName}</span>
                        </div>
                        <div class="ph-room-body">
                            <div class="ph-room-type">Hạng phòng</div>
                            <h5 class="ph-room-title">${rt.typeName}</h5>
                            <div class="ph-room-meta">
                                <span><i class="fas fa-user-friends"></i>Tối đa ${rt.maxGuests} khách</span>
                                <span><i class="fas fa-bed"></i>Tiện nghi cao cấp</span>
                            </div>
                            <p class="ph-room-desc">${rt.description}</p>
                            <div class="ph-room-footer">
                                <div>
                                    <div class="ph-room-price">
                                        <fmt:formatNumber value="${rt.pricePerNight}" type="number" groupingUsed="true"/>
                                        <span class="ph-room-price-label"> VND/đêm</span>
                                    </div>
                                </div>
                                <a href="${pageContext.request.contextPath}/rooms?roomTypeId=${rt.id}"
                                   class="btn-room-book">Xem phòng</a>
                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>
</section>

<%-- ═══ FEATURED ROOMS ═══ --%>
<c:if test="${not empty rooms}">
<section class="ph-section-alt">
    <div class="container">
        <div class="d-flex align-items-end justify-content-between mb-5 flex-wrap gap-2">
            <div>
                <span class="ph-eyebrow">Phòng nổi bật</span>
                <h2 class="ph-title mb-0">Đang sẵn sàng đón bạn</h2>
            </div>
            <a href="${pageContext.request.contextPath}/rooms"
               style="color:var(--ph-gold);font-weight:600;font-size:.9rem;white-space:nowrap;">
               Xem tất cả <i class="fas fa-arrow-right ml-1"></i>
            </a>
        </div>
        <div class="row">
            <c:forEach var="r" items="${rooms}" begin="0" end="2">
                <div class="col-md-4 mb-4 d-flex">
                    <div class="ph-room-card w-100">
                        <div class="ph-room-img-wrap">
                            <img src="${r.roomType.getImageDisplayUrl(pageContext.request.contextPath)}"
                                 class="ph-room-img" alt="${r.roomType.typeName}">
                            <span class="ph-room-badge">Còn trống</span>
                        </div>
                        <div class="ph-room-body">
                            <div class="ph-room-type">${r.roomType.typeName}</div>
                            <h5 class="ph-room-title">Phòng ${r.roomNumber}</h5>
                            <div class="ph-room-meta">
                                <span><i class="fas fa-layer-group"></i>Tầng ${r.floor}</span>
                                <span><i class="fas fa-user-friends"></i>Tối đa ${r.roomType.maxGuests} khách</span>
                            </div>
                            <div class="ph-room-footer">
                                <div class="ph-room-price">
                                    <fmt:formatNumber value="${r.roomType.pricePerNight}" type="number" groupingUsed="true"/>
                                    <span class="ph-room-price-label"> VND/đêm</span>
                                </div>
                                <a href="${pageContext.request.contextPath}/booking/new?roomId=${r.id}"
                                   class="btn-room-book"><i class="fas fa-calendar-plus"></i> Đặt ngay</a>
                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>
</section>
</c:if>

<%-- ═══ TESTIMONIALS ═══ --%>
<section class="ph-section">
    <div class="container">
        <div class="text-center mb-5">
            <span class="ph-eyebrow">Đánh giá</span>
            <h2 class="ph-title">Khách hàng nói gì<br>về chúng tôi</h2>
        </div>
        <div class="row">
            <div class="col-md-4 mb-4">
                <div class="ph-testimonial">
                    <div class="ph-testimonial-stars">
                        <i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i>
                    </div>
                    <p class="ph-testimonial-text">"Phòng rất đẹp, sạch sẽ và tiện nghi. Nhân viên nhiệt tình, hỗ trợ tận tâm. Chắc chắn sẽ quay lại lần sau!"</p>
                    <div class="ph-testimonial-author">
                        <div class="ph-testimonial-avatar">N</div>
                        <div>
                            <div class="ph-testimonial-name">Nguyễn Minh Tuấn</div>
                            <div class="ph-testimonial-loc"><i class="fas fa-map-marker-alt mr-1" style="font-size:.7rem;color:var(--ph-gold);"></i>TP. Hồ Chí Minh</div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-4 mb-4">
                <div class="ph-testimonial">
                    <div class="ph-testimonial-stars">
                        <i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i>
                    </div>
                    <p class="ph-testimonial-text">"Đặt phòng online cực kỳ tiện, nhận mã xác nhận ngay tức thì. Hồ bơi view đẹp, đồ ăn nhà hàng ngon tuyệt!"</p>
                    <div class="ph-testimonial-author">
                        <div class="ph-testimonial-avatar">T</div>
                        <div>
                            <div class="ph-testimonial-name">Trần Thị Lan</div>
                            <div class="ph-testimonial-loc"><i class="fas fa-map-marker-alt mr-1" style="font-size:.7rem;color:var(--ph-gold);"></i>Hà Nội</div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-4 mb-4">
                <div class="ph-testimonial">
                    <div class="ph-testimonial-stars">
                        <i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star-half-alt"></i>
                    </div>
                    <p class="ph-testimonial-text">"Vị trí trung tâm, đi đến các điểm du lịch rất thuận tiện. Phòng sang trọng, view thành phố đẹp về đêm. Xuất sắc!"</p>
                    <div class="ph-testimonial-author">
                        <div class="ph-testimonial-avatar">P</div>
                        <div>
                            <div class="ph-testimonial-name">Phạm Văn Đức</div>
                            <div class="ph-testimonial-loc"><i class="fas fa-map-marker-alt mr-1" style="font-size:.7rem;color:var(--ph-gold);"></i>Đà Nẵng</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<%-- ═══ CTA ═══ --%>
<section class="ph-cta">
    <div class="container">
        <span class="ph-hero-eyebrow">Ưu đãi đặc biệt</span>
        <h2>Đặt phòng ngay hôm nay<br>nhận ngay ưu đãi tốt nhất</h2>
        <p>Đặt trực tiếp qua website để nhận giá tốt nhất và được hỗ trợ ưu tiên trong suốt kỳ nghỉ.</p>
        <a href="${pageContext.request.contextPath}/booking/new" class="btn-cta">
            <i class="fas fa-calendar-check"></i> Đặt phòng ngay
        </a>
        <a href="${pageContext.request.contextPath}/rooms" class="btn-cta btn-cta-outline">
            Xem phòng trống
        </a>
    </div>
</section>

<script>
(function(){
    var fullyBookedDates = [<c:forEach var="d" items="${fullyBookedDates}">"${d}",</c:forEach>];
    var coFp = flatpickr("#heroCheckOut", {
        locale: "vn", dateFormat: "Y-m-d",
        altInput: true, altFormat: "d/m/Y",
        minDate: new Date().fp_incr(1),
        disable: fullyBookedDates
    });
    flatpickr("#heroCheckIn", {
        locale: "vn", dateFormat: "Y-m-d",
        altInput: true, altFormat: "d/m/Y",
        minDate: "today", disable: fullyBookedDates,
        onChange: function(d){ if(d[0]) coFp.set("minDate", new Date(d[0].getTime()+86400000)); }
    });
})();
</script>

<%@ include file="../layout/public-footer.jsp" %>
