const { test, expect } = require('@playwright/test');
const { loginAsAdmin, setFlatpickrDate, todayPlusDays } = require('./helpers');

test.describe.configure({ mode: 'serial' });

const stamp = Date.now();
const roomNumber = `E2EPM${stamp}`;
const offset = 80 + (stamp % 50);
const customerName = `E2E Payment ${stamp}`;

async function selectRoomByNumber(page, number) {
  const value = await page.locator(`select[name="roomId"] option:has-text("${number}")`).getAttribute('value');
  await page.selectOption('select[name="roomId"]', value);
}

test.describe('Admin - Payments, Check-in/out, Reports', () => {
  let page;

  test.beforeAll(async ({ browser }) => {
    page = await browser.newPage();
    await loginAsAdmin(page);

    // dedicated room for this spec
    await page.goto('/admin/rooms/new');
    await page.fill('input[name="roomNumber"]', roomNumber);
    await page.selectOption('select[name="roomTypeId"]', { index: 0 });
    await page.fill('input[name="floor"]', '6');
    await page.click('form button.btn-primary');
    await page.waitForURL('**/admin/rooms');

    // dedicated CONFIRMED booking ready for check-in
    await page.goto('/admin/bookings/new');
    await page.selectOption('select[name="customerId"]', '');
    await page.fill('#newCustomerFullName', customerName);
    await page.fill('#newCustomerPhone', '0933000000');
    await selectRoomByNumber(page, roomNumber);
    await page.selectOption('select[name="status"]', 'CONFIRMED');
    await setFlatpickrDate(page, 'checkInDate', todayPlusDays(offset));
    await setFlatpickrDate(page, 'checkOutDate', todayPlusDays(offset + 2));
    await page.click('form button.btn-primary');
    await page.waitForURL('**/admin/bookings');
  });

  test.afterAll(async () => {
    // booking delete cascades its payment row; then remove the dedicated room
    await page.goto('/admin/bookings');
    const bookingRow = page.locator('table tbody tr', { hasText: customerName });
    if (await bookingRow.count() > 0) {
      page.once('dialog', d => d.accept());
      await bookingRow.locator('a.btn-danger').click();
      await page.waitForURL('**/admin/bookings');
    }
    await page.goto('/admin/rooms');
    const roomRow = page.locator('table tbody tr', { hasText: roomNumber });
    if (await roomRow.count() > 0) {
      page.once('dialog', d => d.accept());
      await roomRow.locator('a.btn-danger').click();
      await page.waitForURL('**/admin/rooms');
    }
    await page.close();
  });

  test('check-in/out page lists the CONFIRMED booking awaiting check-in', async () => {
    await page.goto('/admin/checkinout');
    await expect(page.locator('h1')).toContainText('Check-in / Check-out');
    const row = page.locator('table tbody tr', { hasText: customerName });
    await expect(row).toBeVisible();
    await expect(row.locator('a.btn-primary')).toContainText('Check-in');
  });

  test('check-in moves the booking to the awaiting-checkout table with amount due', async () => {
    const row = page.locator('table tbody tr', { hasText: customerName });
    await row.locator('a.btn-primary').click();
    await page.waitForURL('**/admin/checkinout');
    const updatedRow = page.locator('table tbody tr', { hasText: customerName });
    await expect(updatedRow).toContainText('VND');
    await expect(updatedRow.locator('a.btn-warning')).toContainText('Thanh toán & Check-out');
  });

  test('"Thanh toán & Check-out" opens the payment form pre-filled with the amount due', async () => {
    const row = page.locator('table tbody tr', { hasText: customerName });
    await row.locator('a.btn-warning').click();
    await page.waitForURL('**/admin/payments/new/**');
    await expect(page.locator('.alert-warning')).toContainText('Cần thanh toán đủ trước khi check-out');
    await expect(page.locator('body')).toContainText(customerName);
    await expect(page.locator('input[name="amount"]')).not.toHaveValue('');
  });

  test('submitting the full payment checks the booking out', async () => {
    await page.selectOption('select[name="method"]', 'CASH');
    await page.click('form button[type="submit"]');
    await page.waitForURL('**/admin/checkinout');
    await expect(page.locator('body')).not.toContainText('Exception');
    await expect(page.locator('body')).not.toContainText(customerName);
  });

  test('payment record appears in the payments history', async () => {
    await page.goto('/admin/payments');
    const row = page.locator('table tbody tr', { hasText: customerName });
    await expect(row).toBeVisible();
    await expect(row).toContainText('PAID');
    await expect(row).toContainText('Tiền mặt');
  });

  test('revenue report loads with stat cards', async () => {
    await page.goto('/admin/reports/revenue');
    await expect(page.locator('h1')).toContainText('Báo cáo doanh thu');
    await expect(page.locator('.stat-label').first()).toContainText('Tổng doanh thu');
    await expect(page.locator('.stat-label').nth(1)).toContainText('Số giao dịch thanh toán');
  });

  test('revenue report for today includes the new payment', async () => {
    const today = todayPlusDays(0);
    await setFlatpickrDate(page, 'reportFrom', today);
    await setFlatpickrDate(page, 'reportTo', today);
    await page.click('form button[type="submit"]');
    await page.waitForURL('**/admin/reports/revenue**');
    await expect(page.locator('body')).not.toContainText('Exception');
    await expect(page.locator('table').first()).toContainText(today);
  });

  test('revenue report for a past date range with no data shows empty state', async () => {
    await setFlatpickrDate(page, 'reportFrom', '2020-01-01');
    await setFlatpickrDate(page, 'reportTo', '2020-01-31');
    await page.click('form button[type="submit"]');
    await page.waitForURL('**/admin/reports/revenue**');
    await expect(page.locator('body')).toContainText('Không có dữ liệu trong khoảng thời gian này.');
  });
});
