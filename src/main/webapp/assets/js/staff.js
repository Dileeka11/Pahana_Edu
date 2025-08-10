// Staff Panel JS enhancements
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
})();