const { test, expect } = require('@playwright/test');
const { setFlatpickrDate, todayPlusDays } = require('./helpers');

test.describe.configure({ mode: 'serial' });

const stamp = Date.now();
const email = `e2e.account.${stamp}@test.local`;
const password = 'Test@1234';
const fullName = `E2E Account ${stamp}`;
// Vary the booking date range per run so re-running the suite on the same day
// doesn't collide with a booking left over from a previous run on the same room.
const bookingOffset = 60 + (stamp % 100);

test.describe('Customer account area', () => {
  let page;

  test.beforeAll(async ({ browser }) => {
    page = await browser.newPage();
  });

  test.afterAll(async () => {
    await page.close();
  });

  test('register new customer account', async () => {
    await page.goto('/account/register');
    await page.fill('input[name="fullName"]', fullName);
    await page.fill('input[name="phone"]', '0911000001');
    await page.fill('input[name="email"]', email);
    await page.fill('input[name="identityNumber"]', '079099000222');
    await page.fill('input[name="address"]', '456 E2E Avenue');
    await page.fill('#password', password);
    await page.fill('#confirmPassword', password);
    await page.click('button[type="submit"]');
    await page.waitForURL('**/account');
    await expect(page.locator('h1')).toContainText('Xin chào');
    await expect(page.locator('body')).toContainText(fullName);
  });

  test('registering the same email again shows an error', async () => {
    await page.goto('/account/logout');
    await page.goto('/account/register');
    await page.fill('input[name="fullName"]', fullName);
    await page.fill('input[name="phone"]', '0911000001');
    await page.fill('input[name="email"]', email);
    await page.fill('#password', password);
    await page.fill('#confirmPassword', password);
    await page.click('button[type="submit"]');
    await expect(page.locator('.alert-danger')).toContainText('Email này đã được đăng ký');
  });

  test('login with wrong password shows error', async () => {
    await page.goto('/account/login');
    await page.fill('input[name="email"]', email);
    await page.fill('input[name="password"]', 'wrongpassword');
    await page.click('button[type="submit"]');
    await page.waitForURL('**/account/login**');
    await expect(page.locator('.alert-danger')).toContainText('Email hoặc mật khẩu không đúng');
  });

  test('login with correct credentials shows dashboard', async () => {
    await page.goto('/account/login');
    await page.fill('input[name="email"]', email);
    await page.fill('input[name="password"]', password);
    await page.click('button[type="submit"]');
    await page.waitForURL('**/account');
    await expect(page.locator('h1')).toContainText('Xin chào');
    await expect(page.locator('.stat-value').first()).toHaveText('0');
    await expect(page.locator('body')).toContainText('Bạn chưa có lượt đặt phòng nào');
  });

  test('logged-in customer can create a booking pre-filled with account info', async () => {
    await page.goto('/booking/new?roomId=5');
    await expect(page.locator('.alert-info')).toContainText(email);
    await expect(page.locator('input[name="fullName"]')).toHaveValue(fullName);
    await expect(page.locator('input[name="phone"]')).toHaveValue('0911000001');
    await setFlatpickrDate(page, 'bookCheckIn', todayPlusDays(bookingOffset));
    await setFlatpickrDate(page, 'bookCheckOut', todayPlusDays(bookingOffset + 2));
    await page.fill('textarea[name="note"]', 'E2E logged-in booking');
    await page.click('form button.btn-primary');
    await page.waitForURL('**/rooms?success=1**');
    await expect(page.locator('.alert-success')).toContainText('Đặt phòng thành công');
  });

  test('dashboard shows the new booking in history and links to invoice', async () => {
    await page.goto('/account');
    await expect(page.locator('.stat-value').first()).toHaveText('1');
    const row = page.locator('table tbody tr').first();
    await expect(row).toContainText('PENDING');
    await expect(row).toContainText('301');
    await row.locator('a.btn-outline-primary').click();
    await page.waitForURL('**/account/bookings/**');
    await expect(page.locator('h1')).toContainText('Đặt phòng #');
    await expect(page.locator('.badge-status-PENDING')).toBeVisible();
    await expect(page.locator('body')).toContainText('301');
    await expect(page.locator('body')).toContainText('Chưa có thanh toán nào được ghi nhận');
  });

  test('logout returns to public site without account access', async () => {
    await page.goto('/account');
    await page.click('a:has-text("Đăng xuất")');
    await page.waitForURL('**/');
    await page.goto('/account');
    await page.waitForURL('**/account/login');
  });
});
