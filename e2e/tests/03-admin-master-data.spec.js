const { test, expect } = require('@playwright/test');
const { loginAsAdmin } = require('./helpers');

test.describe.configure({ mode: 'serial' });

const stamp = Date.now();

test.describe('Admin - Room Types CRUD', () => {
  let page;
  const typeName = `E2E RoomType ${stamp}`;

  test.beforeAll(async ({ browser }) => {
    page = await browser.newPage();
    await loginAsAdmin(page);
  });

  test.afterAll(async () => {
    await page.close();
  });

  test('list page shows existing room types', async () => {
    await page.goto('/admin/room-types');
    await expect(page.locator('h1')).toContainText('Quản lý loại phòng');
    await expect(page.locator('table thead')).toContainText('Tên loại');
    await expect(page.locator('table tbody tr').first()).toBeVisible();
  });

  test('create a new room type', async () => {
    await page.goto('/admin/room-types/new');
    await page.fill('input[name="typeName"]', typeName);
    await page.fill('input[name="pricePerNight"]', '500000');
    await page.fill('input[name="maxGuests"]', '2');
    await page.fill('textarea[name="description"]', 'E2E test room type');
    await page.click('form button.btn-primary');
    await page.waitForURL('**/admin/room-types');
    const row = page.locator('table tbody tr', { hasText: typeName });
    await expect(row).toContainText('500,000');
    await expect(row).toContainText('2');
  });

  test('edit the room type', async () => {
    const row = page.locator('table tbody tr', { hasText: typeName });
    await row.locator('a.btn-warning').click();
    await page.waitForURL('**/admin/room-types/edit/**');
    await expect(page.locator('input[name="typeName"]')).toHaveValue(typeName);
    await page.fill('input[name="pricePerNight"]', '650000');
    await page.click('form button.btn-primary');
    await page.waitForURL('**/admin/room-types');
    const updatedRow = page.locator('table tbody tr', { hasText: typeName });
    await expect(updatedRow).toContainText('650,000');
  });

  test('delete the room type', async () => {
    const row = page.locator('table tbody tr', { hasText: typeName });
    page.once('dialog', dialog => dialog.accept());
    await row.locator('a.btn-danger').click();
    await page.waitForURL('**/admin/room-types');
    await expect(page.locator('table tbody')).not.toContainText(typeName);
  });
});

test.describe('Admin - Rooms CRUD', () => {
  let page;
  const roomNumber = `E2E${stamp}`;

  test.beforeAll(async ({ browser }) => {
    page = await browser.newPage();
    await loginAsAdmin(page);
  });

  test.afterAll(async () => {
    await page.close();
  });

  test('list page shows existing rooms', async () => {
    await page.goto('/admin/rooms');
    await expect(page.locator('h1')).toContainText('Quản lý phòng');
    await expect(page.locator('table thead')).toContainText('Số phòng');
    await expect(page.locator('table tbody tr').first()).toBeVisible();
  });

  test('create a new room', async () => {
    await page.goto('/admin/rooms/new');
    await page.fill('input[name="roomNumber"]', roomNumber);
    await page.selectOption('select[name="roomTypeId"]', { index: 0 });
    await page.fill('input[name="floor"]', '9');
    await page.fill('textarea[name="description"]', 'E2E test room');
    await page.click('form button.btn-primary');
    await page.waitForURL('**/admin/rooms');
    const row = page.locator('table tbody tr', { hasText: roomNumber });
    await expect(row).toContainText('9');
    await expect(row.locator('.badge')).toContainText('AVAILABLE');
  });

  test('edit the room', async () => {
    const row = page.locator('table tbody tr', { hasText: roomNumber });
    await row.locator('a.btn-warning').click();
    await page.waitForURL('**/admin/rooms/edit/**');
    await expect(page.locator('input[name="roomNumber"]')).toHaveValue(roomNumber);
    await page.fill('input[name="floor"]', '10');
    await page.selectOption('select[name="status"]', 'MAINTENANCE');
    await page.click('form button.btn-primary');
    await page.waitForURL('**/admin/rooms');
    const updatedRow = page.locator('table tbody tr', { hasText: roomNumber });
    await expect(updatedRow).toContainText('10');
    await expect(updatedRow.locator('.badge')).toContainText('MAINTENANCE');
  });

  test('delete the room', async () => {
    const row = page.locator('table tbody tr', { hasText: roomNumber });
    page.once('dialog', dialog => dialog.accept());
    await row.locator('a.btn-danger').click();
    await page.waitForURL('**/admin/rooms');
    await expect(page.locator('table tbody')).not.toContainText(roomNumber);
  });
});

test.describe('Admin - Customers CRUD', () => {
  let page;
  const fullName = `E2E Customer ${stamp}`;
  const email = `e2e.customer.${stamp}@test.local`;

  test.beforeAll(async ({ browser }) => {
    page = await browser.newPage();
    await loginAsAdmin(page);
  });

  test.afterAll(async () => {
    await page.close();
  });

  test('list page shows existing customers', async () => {
    await page.goto('/admin/customers');
    await expect(page.locator('h1')).toContainText('Quản lý khách hàng');
    await expect(page.locator('table thead')).toContainText('Họ tên');
  });

  test('create a new customer', async () => {
    await page.goto('/admin/customers/new');
    await page.fill('input[name="fullName"]', fullName);
    await page.fill('input[name="phone"]', '0987650000');
    await page.fill('input[name="email"]', email);
    await page.fill('input[name="identityNumber"]', '079099111222');
    await page.fill('textarea[name="address"]', '789 E2E Street');
    await page.click('form button.btn-primary');
    await page.waitForURL('**/admin/customers');
    const row = page.locator('table tbody tr', { hasText: email });
    await expect(row).toContainText(fullName);
    await expect(row).toContainText('0987650000');
  });

  test('edit the customer', async () => {
    const row = page.locator('table tbody tr', { hasText: email });
    await row.locator('a.btn-warning').click();
    await page.waitForURL('**/admin/customers/edit/**');
    await expect(page.locator('input[name="fullName"]')).toHaveValue(fullName);
    await page.fill('input[name="phone"]', '0987650001');
    await page.click('form button.btn-primary');
    await page.waitForURL('**/admin/customers');
    const updatedRow = page.locator('table tbody tr', { hasText: email });
    await expect(updatedRow).toContainText('0987650001');
  });

  test('delete the customer', async () => {
    const row = page.locator('table tbody tr', { hasText: email });
    page.once('dialog', dialog => dialog.accept());
    await row.locator('a.btn-danger').click();
    await page.waitForURL('**/admin/customers');
    await expect(page.locator('table tbody')).not.toContainText(email);
  });
});
