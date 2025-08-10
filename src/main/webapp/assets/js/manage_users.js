// Manage Users page JS
(function () {
  const prefersReduced = window.matchMedia('(prefers-reduced-motion: reduce)').matches;

  // Set footer year
  const yearEl = document.getElementById('sp-year');
  if (yearEl) {
    yearEl.textContent = new Date().getFullYear();
  }

  // Ripple effect for .sp-btn and .sp-pill
  function attachRipple(el) {
    if (!el) return;
    el.style.position ||= 'relative';
    el.style.overflow ||= 'hidden';

    el.addEventListener('click', function (e) {
      if (prefersReduced) return;
      const rect = el.getBoundingClientRect();
      const size = Math.max(rect.width, rect.height);
      const ripple = document.createElement('span');
      ripple.className = 'sp-ripple';
      ripple.style.position = 'absolute';
      ripple.style.borderRadius = '50%';
      ripple.style.pointerEvents = 'none';
      ripple.style.width = ripple.style.height = size + 'px';
      ripple.style.left = e.clientX - rect.left - size / 2 + 'px';
      ripple.style.top = e.clientY - rect.top - size / 2 + 'px';
      ripple.style.background = 'rgba(30,144,255,0.25)';
      ripple.style.transform = 'scale(0)';
      ripple.style.opacity = '0.9';
      ripple.style.transition = 'transform 450ms ease, opacity 600ms ease';

      el.appendChild(ripple);
      requestAnimationFrame(() => {
        ripple.style.transform = 'scale(1)';
        ripple.style.opacity = '0';
      });
      setTimeout(() => ripple.remove(), 650);
    });
  }

  document.querySelectorAll('.sp-btn, .sp-pill').forEach(attachRipple);

  // Client-side search filtering
  function normalize(s) {
    return (s || '').toString().toLowerCase().trim();
  }

  function getRowText(tr) {
    // Collect text from relevant cells: ID, Account, Name, Address, Telephone, Email
    const cells = tr.querySelectorAll('td');
    let parts = [];
    cells.forEach((td, idx) => {
      if (idx === 2 || idx === 3 || idx === 4 || idx === 5) {
        // Inputs in these cells
        const input = td.querySelector('input');
        parts.push(input ? input.value : '');
      } else if (idx <= 1) {
        parts.push(td.textContent);
      }
    });
    return normalize(parts.join(' '));
  }

  const form = document.querySelector('form.sp-toolbar');
  const input = form ? form.querySelector('input[name="q"]') : null;
  const table = document.querySelector('.sp-table');
  const tbody = table ? table.querySelector('tbody') : null;

  // Create or reuse an empty row for client-side empty state
  function ensureEmptyRow() {
    if (!tbody) return null;
    let emptyRow = tbody.querySelector('tr[data-empty-row="true"]');
    if (!emptyRow) {
      emptyRow = document.createElement('tr');
      emptyRow.setAttribute('data-empty-row', 'true');
      const td = document.createElement('td');
      td.colSpan = 8;
      td.className = 'sp-empty';
      td.innerHTML = '<i class="fa-regular fa-face-frown"></i> No users found.';
      emptyRow.appendChild(td);
      emptyRow.style.display = 'none';
      tbody.appendChild(emptyRow);
    }
    return emptyRow;
  }

  function filterRows(term) {
    if (!tbody) return;
    const rows = Array.from(tbody.querySelectorAll('tr'))
      .filter(r => !r.hasAttribute('data-empty-row'));
    const nterm = normalize(term);
    let visibleCount = 0;

    rows.forEach(tr => {
      const text = getRowText(tr);
      const match = nterm === '' || text.includes(nterm);
      tr.style.display = match ? '' : 'none';
      if (match) visibleCount++;
    });

    const emptyRow = ensureEmptyRow();
    if (emptyRow) emptyRow.style.display = visibleCount === 0 ? '' : 'none';
  }

  if (input && tbody) {
    // Live filter as user types
    input.addEventListener('input', () => filterRows(input.value));

    // Intercept Search button submit to do client-side filtering
    if (form) {
      form.addEventListener('submit', (e) => {
        e.preventDefault();
        filterRows(input.value);
      });
    }

    // Initialize filter using current query value (if any)
    filterRows(input.value || '');
  }
})();