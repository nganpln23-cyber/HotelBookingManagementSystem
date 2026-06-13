const { test, expect } = require('@playwright/test');
const { loginAsAdmin, setFlatpickrDate, todayPlusDays } = require('./helpers');

test.describe.configure({ mode: 'serial' });

const stamp = Date.now();
const roomNumber = `E2EBK${stamp}`;
const offset1 = 70 + (stamp % 50);

const customerA = `E2E Booking A ${stamp}`;
const customerB = `E2E Booking B ${stamp}`;
const customerC = `E2E Booking C ${stamp}`;

async function selectRoomByNumber(page, number) {
  const value = await page.locator(`select[name="roomId"] option:has-text("${number}")`).getAttribute('value');
  await page.selectOption('select[name="roomId"]', value);
}

async function fillNewBookingForm(page, { customerName, phone, status }) {
  await page.goto('/admin/bookings/new');
  await page.selectOption('select[name="customerId"]', '');
  await page.fill('#newCustomerFullName', customerName);
  await page.fill('#newCustomerPhone', phone);
  await selectRoomByNumber(page, roomNumber);
  if (status) {
    await page.selectOption('select[name="status"]', status);
  }
  await setFlatpickrDate(page, 'checkInDate', todayPlusDays(offset1));
  await setFlatpickrDate(page, 'checkOutDate', todayPlusDays(offset1 + 2));
  await page.click('form button.btn-primary');
  await page.waitForURL('**/admin/bookings');
}

test.describe('Admin - Bookings CRUD and status workflow', () => {
  let page;

  test.beforeAll(async ({ browser }) => {
    page = await browser.newPage();
    await loginAsAdmin(page);
    // create a dedicated room for this spec so the workflow doesn't collide with real data
    await page.goto('/admin/rooms/new');
    await page.fill('input[name="roomNumber"]', roomNumber);
    await page.selectOption('select[name="roomTypeId"]', { index: 0 });
    await page.fill('input[name="floor"]', '5');
    await page.click('form button.btn-primary');
    await page.waitForURL('**/admin/rooms');
  });

  test.afterAll(async () => {
    await page.goto('/admin/rooms');
    const row = page.locator('table tbody tr', { hasText: roomNumber });
    if (await row.count() > 0) {
      page.once('dialog', d => d.accept());
      await row.locator('a.btn-danger').click();
      await page.waitForURL('**/admin/rooms');
    }
    await page.close();
  });

  test('list page loads with bookings table', async () => {
    await page.goto('/admin/bookings');
    await expect(page.locator('h1')).toContainText('Quản lý đặt phòng');
    await expect(page.locator('table thead')).toContainText('Trạng thái');
  });

  test('new booking form defaults status to CONFIRMED', async () => {
    await page.goto('/admin/bookings/new');
    await expect(page.locator('select[name="status"]')).toHaveValue('CONFIRMED');
  });

  test('create booking A as PENDING', async () => {
    await fillNewBookingForm(page, { customerName: customerA, phone: '0922000001', status: 'PENDING' });
    const row = page.locator('table tbody tr', { hasText: customerA });
    await expect(row).toContainText('PENDING');
  });

  test('confirm booking A: PENDING -> CONFIRMED', async () => {
    const row = page.locator('table tbody tr', { hasText: customerA });
    await row.locator('a.btn-success').click();
    await page.waitForURL('**/admin/bookings');
    const updatedRow = page.locator('table tbody tr', { hasText: customerA });
    await expect(updatedRow).toContainText('CONFIRMED');
    await expect(updatedRow.locator('a.btn-success')).toHaveCount(0);
    await expect(updatedRow.locator('a.btn-danger')).toHaveCount(0);
    await expect(updatedRow.locator('a.btn-info')).toContainText('Check-in');
  });

  test('create booking B with the same room/dates as PENDING', async () => {
    await fillNewBookingForm(page, { customerName: customerB, phone: '0922000002', status: 'PENDING' });
    const row = page.locator('table tbody tr', { hasText: customerB });
    await expect(row).toContainText('PENDING');
  });

  test('confirming booking B is rejected because room is already confirmed for those dates', async () => {
    const row = page.locator('table tbody tr', { hasText: customerB });
    await row.locator('a.btn-success').click();
    await page.waitForURL('**/admin/bookings');
    await expect(page.locator('body')).not.toContainText('Exception');
    await expect(page.locator('.alert-danger')).toContainText('Không thể xác nhận');
    const updatedRow = page.locator('table tbody tr', { hasText: customerB });
    await expect(updatedRow).toContainText('PENDING');
  });

  test('delete booking B (PENDING can be deleted directly)', async () => {
    const row = page.locator('table tbody tr', { hasText: customerB });
    page.once('dialog', d => d.accept());
    await row.locator('a.btn-danger').click();
    await page.waitForURL('**/admin/bookings');
    await expect(page.locator('table tbody')).not.toContainText(customerB);
  });

  test('check-in booking A: CONFIRMED -> CHECKED_IN', async () => {
    const row = page.locator('table tbody tr', { hasText: customerA });
    await row.locator('a.btn-info').click();
    await page.waitForURL('**/admin/bookings');
    const updatedRow = page.locator('table tbody tr', { hasText: customerA });
    await expect(updatedRow).toContainText('CHECKED_IN');
    await expect(updatedRow.locator('a.btn-dark')).toHaveCount(0);
    await expect(updatedRow.locator('a.btn-danger')).toHaveCount(0);
    await expect(updatedRow.locator('a.btn-secondary')).toContainText('Check-out');
    await expect(updatedRow.locator('a.btn-primary')).toContainText('Thanh toán');
  });

  test('cancelling a CHECKED_IN booking via direct URL is rejected', async () => {
    const row = page.locator('table tbody tr', { hasText: customerA });
    const editHref = await row.locator('a.btn-warning').getAttribute('href');
    const bookingId = editHref.split('/').pop();

    await page.goto(`/admin/bookings/cancel/${bookingId}`);
    await page.waitForURL('**/admin/dashboard');
    await expect(page.locator('body')).not.toContainText('Exception');
    await expect(page.locator('.alert-danger')).toContainText('Chỉ có thể hủy đơn đặt phòng ở trạng thái PENDING hoặc CONFIRMED');

    await page.goto('/admin/bookings');
    const updatedRow = page.locator('table tbody tr', { hasText: customerA });
    await expect(updatedRow).toContainText('CHECKED_IN');
  });

  test('check-out booking A: CHECKED_IN -> CHECKED_OUT', async () => {
    const row = page.locator('table tbody tr', { hasText: customerA });
    await row.locator('a.btn-secondary').click();
    await page.waitForURL('**/admin/bookings');
    const updatedRow = page.locator('table tbody tr', { hasText: customerA });
    await expect(updatedRow).toContainText('CHECKED_OUT');
    await expect(updatedRow.locator('a.btn-primary')).toContainText('Thanh toán');
    await expect(updatedRow.locator('a.btn-danger')).toBeVisible();
  });

  test('delete booking A (CHECKED_OUT can be deleted)', async () => {
    const row = page.locator('table tbody tr', { hasText: customerA });
    page.once('dialog', d => d.accept());
    await row.locator('a.btn-danger').click();
    await page.waitForURL('**/admin/bookings');
    await expect(page.locator('table tbody')).not.toContainText(customerA);
  });

  test('create booking C as PENDING and cancel it', async () => {
    await fillNewBookingForm(page, { customerName: customerC, phone: '0922000003', status: 'PENDING' });
    const row = page.locator('table tbody tr', { hasText: customerC });
    await expect(row).toContainText('PENDING');

    page.once('dialog', d => d.accept());
    await row.locator('a.btn-dark').click();
    await page.waitForURL('**/admin/bookings');
    const updatedRow = page.locator('table tbody tr', { hasText: customerC });
    await expect(updatedRow).toContainText('CANCELLED');
  });

  test('cancelled booking C only shows Sửa/Xóa actions and can be deleted', async () => {
    const row = page.locator('table tbody tr', { hasText: customerC });
    await expect(row.locator('a.btn-success')).toHaveCount(0);
    await expect(row.locator('a.btn-info')).toHaveCount(0);
    await expect(row.locator('a.btn-secondary')).toHaveCount(0);
    await expect(row.locator('a.btn-dark')).toHaveCount(0);
    await expect(row.locator('a.btn-primary')).toHaveCount(0);
    await expect(row.locator('a.btn-warning')).toBeVisible();
    await expect(row.locator('a.btn-danger')).toBeVisible();

    page.once('dialog', d => d.accept());
    await row.locator('a.btn-danger').click();
    await page.waitForURL('**/admin/bookings');
    await expect(page.locator('table tbody')).not.toContainText(customerC);
  });
});
