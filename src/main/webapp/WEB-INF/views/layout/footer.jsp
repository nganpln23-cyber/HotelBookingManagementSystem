            </div>
        </section>
    </div>

    <footer class="main-footer text-sm">
        <strong>Hotel Booking Management System</strong> - Spring MVC + MySQL
    </footer>
</div>
<script src="https://cdn.jsdelivr.net/npm/jquery@3.6.4/dist/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/admin-lte@3.2/dist/js/adminlte.min.js"></script>
<script>
document.querySelectorAll('.money-input').forEach(function (input) {
    function reformat() {
        var cursorPos = input.selectionStart;
        var digitsBeforeCursor = input.value.slice(0, cursorPos).replace(/\D/g, '').length;
        var raw = input.value.replace(/\D/g, '');
        input.value = raw ? Number(raw).toLocaleString('vi-VN') : '';
        var pos = 0, digits = 0;
        while (pos < input.value.length && digits < digitsBeforeCursor) {
            if (/\d/.test(input.value[pos])) digits++;
            pos++;
        }
        input.setSelectionRange(pos, pos);
    }
    var initial = parseFloat(input.value);
    input.value = isNaN(initial) ? '' : Math.round(initial).toLocaleString('vi-VN');
    input.addEventListener('input', reformat);
    input.form.addEventListener('submit', function () {
        input.value = input.value.replace(/\D/g, '');
    });
});
</script>
</body>
</html>
