requestAnimationFrame = window.requestAnimationFrame || window.mozRequestAnimationFrame ||
  window.webkitRequestAnimationFrame || window.msRequestAnimationFrame

window.requestAnimationFrame = requestAnimationFrame

cancelAnimationFrame = window.cancelAnimationFrame || window.mozCancelAnimationFrame

window.cancelAnimationFrame = cancelAnimationFrame
