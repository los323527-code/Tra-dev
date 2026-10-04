/* Clawd widget — floating pet that keeps animating on your website.
   Usage: <script src="/clawd-widget/clawd.js" defer></script> */
(function () {
  var BASE = (document.currentScript && document.currentScript.src.replace(/clawd\.js.*$/, '')) || '/clawd-widget/';
  var POSES = [
    'clawd-idle-look', 'clawd-working-typing', 'clawd-happy', 'clawd-working-juggling',
    'clawd-headphones-groove', 'clawd-working-thinking', 'clawd-idle-reading',
    'clawd-working-building', 'clawd-heart-eyes', 'clawd-working-debugger', 'clawd-idle-living'
  ];
  var SIZE = 110;        // px (width & height)
  var EVERY = 6000;      // ms between pose changes

  var img = document.createElement('img');
  img.alt = 'Clawd';
  img.draggable = false;
  img.style.cssText =
    'position:fixed;right:12px;bottom:12px;width:' + SIZE + 'px;height:' + SIZE + 'px;' +
    'z-index:99999;cursor:grab;touch-action:none;user-select:none;-webkit-user-select:none;' +
    'filter:drop-shadow(0 4px 6px rgba(0,0,0,.35));';

  var i = 0, timer = null, busy = false;
  function show(name) { img.src = BASE + 'clawd/' + name + '.svg'; }
  function next() { if (busy) return; i = (i + 1) % POSES.length; show(POSES[i]); }
  function start() { clearInterval(timer); timer = setInterval(next, EVERY); }

  show(POSES[0]);
  document.body.appendChild(img);
  start();

  // Tap = jump, drag = move anywhere
  var drag = null, moved = false;
  img.addEventListener('pointerdown', function (e) {
    var r = img.getBoundingClientRect();
    drag = { dx: e.clientX - r.left, dy: e.clientY - r.top };
    moved = false;
    img.setPointerCapture(e.pointerId);
    img.style.cursor = 'grabbing';
  });
  img.addEventListener('pointermove', function (e) {
    if (!drag) return;
    moved = true;
    var x = Math.min(Math.max(0, e.clientX - drag.dx), innerWidth - SIZE);
    var y = Math.min(Math.max(0, e.clientY - drag.dy), innerHeight - SIZE);
    img.style.left = x + 'px'; img.style.top = y + 'px';
    img.style.right = 'auto'; img.style.bottom = 'auto';
  });
  img.addEventListener('pointerup', function () {
    drag = null; img.style.cursor = 'grab';
    if (!moved) {
      busy = true; show('clawd-react-double-jump');
      setTimeout(function () { busy = false; show(POSES[i]); }, 1500);
    }
  });
})();
