requestAnimationFrame = window.requestAnimationFrame || window.mozRequestAnimationFrame ||
  window.webkitRequestAnimationFrame || window.msRequestAnimationFrame

cancelAnimationFrame = window.cancelAnimationFrame || window.mozCancelAnimationFrame

module.exports =
  requestAnimationFrame: requestAnimationFrame
  cancelAnimationFrame: cancelAnimationFrame
