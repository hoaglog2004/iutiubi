document.addEventListener('DOMContentLoaded', function () {
  // Collapse/expand form
  const collapseBtn = document.getElementById('collapseFormBtn');
  const formInner = document.querySelector('.vm-form');
  if (collapseBtn && formInner) {
    collapseBtn.addEventListener('click', function () {
      if (formInner.style.display === 'none') {
        formInner.style.display = '';
        collapseBtn.textContent = 'Thu gọn';
      } else {
        formInner.style.display = 'none';
        collapseBtn.textContent = 'Mở form';
      }
    });
  }

  // Simple client-side search filter (optional)
  const search = document.getElementById('vmSearch');
  if (search) {
    search.addEventListener('input', function () {
      const q = this.value.trim().toLowerCase();
      document.querySelectorAll('#vmTableBody tr').forEach(tr => {
        const title = (tr.children[2]?.textContent || '').toLowerCase();
        tr.style.display = title.includes(q) ? '' : 'none';
      });
    });
  }
});