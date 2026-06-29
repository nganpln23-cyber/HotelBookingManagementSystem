<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
            </div>
        </section>
    </div>

    <footer class="main-footer text-sm">
        <strong>Grand Beach Hotel</strong> &mdash; Hệ thống quản lý &copy; 2026
    </footer>
</div>

<script src="https://cdn.jsdelivr.net/npm/admin-lte@3.2/dist/js/adminlte.min.js"></script>

<script>
document.querySelectorAll('.money-input').forEach(function (input) {
    function reformat() {
        var pos = input.selectionStart;
        var digitsBeforeCursor = input.value.slice(0, pos).replace(/\D/g, '').length;
        var raw = input.value.replace(/\D/g, '');
        input.value = raw ? Number(raw).toLocaleString('vi-VN') : '';
        var p = 0, d = 0;
        while (p < input.value.length && d < digitsBeforeCursor) {
            if (/\d/.test(input.value[p])) d++;
            p++;
        }
        input.setSelectionRange(p, p);
    }
    var initial = parseFloat(input.value);
    input.value = isNaN(initial) ? '' : Math.round(initial).toLocaleString('vi-VN');
    input.addEventListener('input', reformat);
    if (input.form) {
        input.form.addEventListener('submit', function () {
            input.value = input.value.replace(/\D/g, '');
        });
    }
});

setTimeout(function () {
    document.querySelectorAll('.alert.alert-dismissible').forEach(function (el) {
        el.style.transition = 'opacity .5s';
        el.style.opacity = '0';
        setTimeout(function () { el.remove(); }, 500);
    });
}, 5000);
</script>
</body>
</html>
