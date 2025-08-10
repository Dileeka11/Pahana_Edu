/* Staff helper JS */
(function(){
  const toast = (msg, timeout=2500) => {
    let el = document.querySelector('.toast');
    if(!el){
      el = document.createElement('div');
      el.className = 'toast';
      document.body.appendChild(el);
    }
    el.textContent = msg;
    el.classList.add('show');
    setTimeout(()=> el.classList.remove('show'), timeout);
  };

  // Delegate delete confirmations if buttons have data-confirm
  document.addEventListener('click', (e)=>{
    const btn = e.target.closest('[data-confirm]');
    if(!btn) return;
    const msg = btn.getAttribute('data-confirm') || 'Are you sure?';
    if(!confirm(msg)) {
      e.preventDefault();
      e.stopPropagation();
    }
  });

  // Expose globally if needed
  window.StaffUI = { toast };
})();
