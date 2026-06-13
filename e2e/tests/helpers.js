// Shared helpers for E2E tests

async function loginAsAdmin(page, username = 'admin', password = 'admin123') {
  await page.goto('/login');
  await page.fill('input[name="username"]', username);
  await page.fill('input[name="password"]', password);
  await page.click('button[type="submit"]');
  await page.waitForURL('**/admin/dashboard');
}

async function logoutAdmin(page) {
  await page.goto('/admin/dashboard');
  await page.click('a.dropdown-toggle, a[data-toggle="dropdown"]');
  await page.click('a.dropdown-item.text-danger');
}

/** Sets a flatpickr (altInput) date field by id, e.g. "checkInDate" -> #checkInDate hidden input.
 *  Pass triggerChange=false to skip firing the field's onChange handler (useful when that
 *  handler would adjust another field's minDate and clear a value set out of order). */
async function setFlatpickrDate(page, elementId, dateStr, triggerChange = true) {
  await page.evaluate(({ id, value, trigger }) => {
    const el = document.getElementById(id);
    if (!el) throw new Error('Element not found: ' + id);
    if (el._flatpickr) {
      el._flatpickr.setDate(value, trigger);
    } else {
      el.value = value;
      el.dispatchEvent(new Event('input', { bubbles: true }));
      el.dispatchEvent(new Event('change', { bubbles: true }));
    }
  }, { id: elementId, value: dateStr, trigger: triggerChange });
}

function todayPlusDays(days) {
  const d = new Date();
  d.setDate(d.getDate() + days);
  const yyyy = d.getFullYear();
  const mm = String(d.getMonth() + 1).padStart(2, '0');
  const dd = String(d.getDate()).padStart(2, '0');
  return `${yyyy}-${mm}-${dd}`;
}

module.exports = { loginAsAdmin, logoutAdmin, setFlatpickrDate, todayPlusDays };
