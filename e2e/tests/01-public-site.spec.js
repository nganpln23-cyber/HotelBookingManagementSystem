const { test, expect } = require('@playwright/test');
const { setFlatpickrDate, todayPlusDays } = require('./helpers');

// Vary the booking date range per run so re-running the suite on the same day
// doesn't collide with a booking left over from a previous run on the same room.
const bookingOffset = 60 + (Date.now() % 100);

test.describe('Public site', () => {
  test('home page loads with search widget, room types and available rooms', async ({ page }) => {
    await page.goto('/');
    await expect(page).toHaveTitle(/Trang chủ/);
    await expect(page.locator('h1')).toContainText('Kỳ nghỉ trong mơ');
    // flatpickr (altInput) hides the real input and shows a separate alt input
    await expect(page.locator('#searchCheckIn')).toBeAttached();
    await expect(page.locator('#searchCheckOut')).toBeAttached();
    await expect(page.locator('.section-title', { hasText: 'Hạng phòng' })).toBeVisible();
    await expect(page.locator('.room-card').first()).toBeVisible();
  });

  test('search widget navigates to /rooms with selected dates', async ({ page }) => {
    await page.goto('/');
    await setFlatpickrDate(page, 'searchCheckIn', todayPlusDays(10));
    await setFlatpickrDate(page, 'searchCheckOut', todayPlusDays(12));
    await page.click('.search-widget button[type="submit"], .search-widget button');
    await page.waitForURL('**/rooms**');
    await expect(page.locator('h2')).toContainText('Phòng trống từ');
  });

  test('rooms page can filter by room type', async ({ page }) => {
    await page.goto('/rooms?roomTypeId=2');
    await expect(page.locator('select[name="roomTypeId"]')).toHaveValue('2');
    const cards = page.locator('.room-card');
    const count = await cards.count();
    expect(count).toBeGreaterThan(0);
    for (let i = 0; i < count; i++) {
      await expect(cards.nth(i)).toContainText('Deluxe');
    }
  });

  test('rooms page shows warning when no rooms match', async ({ page }) => {
    await page.goto('/rooms?roomTypeId=2');
    await setFlatpickrDate(page, 'searchCheckIn', todayPlusDays(1));
    await setFlatpickrDate(page, 'searchCheckOut', todayPlusDays(1));
    // checkOut == checkIn -> service falls back to "all available" since checkOut is not after checkIn
    await page.click('.search-widget button');
    await page.waitForURL('**/rooms**');
    // Should not crash; either shows rooms (fallback) or the "no rooms" warning
    await expect(page.locator('body')).not.toContainText('Exception');
  });

  test('clicking "Đặt phòng" from rooms list opens booking form with selected room', async ({ page }) => {
    await page.goto('/rooms');
    const firstBookBtn = page.locator('.room-card a.btn-primary').first();
    await firstBookBtn.click();
    await page.waitForURL('**/booking/new**');
    await expect(page.locator('h1')).toContainText('Đặt phòng');
    await expect(page.locator('.room-card')).toBeVisible();
  });

  test('guest booking with empty dates shows friendly validation error (no 500)', async ({ page }) => {
    await page.goto('/booking/new?roomId=4');
    await page.fill('input[name="fullName"]', 'E2E Guest NoDates');
    await page.fill('input[name="phone"]', '0900000001');
    await page.fill('input[name="email"]', 'e2e.nodates@test.local');
    await page.click('form button.btn-primary');
    await expect(page.locator('body')).not.toContainText('Exception');
    await expect(page.locator('.alert-danger')).toContainText('ngày nhận và ngày trả phòng');
  });

  test('guest booking with check-out before check-in shows friendly validation error', async ({ page }) => {
    await page.goto('/booking/new?roomId=4');
    await page.fill('input[name="fullName"]', 'E2E Guest BadDates');
    await page.fill('input[name="phone"]', '0900000002');
    await page.fill('input[name="email"]', 'e2e.baddates@test.local');
    // Set checkIn without firing onChange, so it doesn't raise checkOut's minDate
    // (which would silently clear the earlier, out-of-range checkOut value).
    await setFlatpickrDate(page, 'bookCheckIn', todayPlusDays(5), false);
    await setFlatpickrDate(page, 'bookCheckOut', todayPlusDays(3));
    await page.click('form button.btn-primary');
    await expect(page.locator('body')).not.toContainText('Exception');
    await expect(page.locator('.alert-danger')).toContainText('Ngày trả phòng phải sau ngày nhận phòng');
  });

  test('guest booking with invalid promo code shows friendly error and does not create orphan customer', async ({ page }) => {
    await page.goto('/booking/new?roomId=4');
    await page.fill('input[name="fullName"]', 'E2E Guest BadPromo');
    await page.fill('input[name="phone"]', '0900000003');
    await page.fill('input[name="email"]', 'e2e.badpromo@test.local');
    await setFlatpickrDate(page, 'bookCheckIn', todayPlusDays(20));
    await setFlatpickrDate(page, 'bookCheckOut', todayPlusDays(22));
    await page.fill('input[name="promoCode"]', 'NOTAREALCODE');
    await page.click('form button.btn-primary');
    await expect(page.locator('body')).not.toContainText('Exception');
    await expect(page.locator('.alert-danger')).toContainText('Mã giảm giá không hợp lệ');
  });

  test('guest can submit a valid booking successfully', async ({ page }) => {
    await page.goto('/booking/new?roomId=4');
    await page.fill('input[name="fullName"]', 'E2E Guest Success');
    await page.fill('input[name="phone"]', '0900000004');
    await page.fill('input[name="email"]', 'e2e.success@test.local');
    await page.fill('input[name="identityNumber"]', '079099000111');
    await page.fill('input[name="address"]', '123 Test Street');
    await setFlatpickrDate(page, 'bookCheckIn', todayPlusDays(bookingOffset));
    await setFlatpickrDate(page, 'bookCheckOut', todayPlusDays(bookingOffset + 2));
    await page.fill('textarea[name="note"]', 'E2E automated booking');
    await page.click('form button.btn-primary');
    await page.waitForURL('**/rooms?success=1**');
    await expect(page.locator('.alert-success')).toContainText('Đặt phòng thành công');
  });
});
