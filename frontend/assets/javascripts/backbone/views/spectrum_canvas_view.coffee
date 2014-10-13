_ = require('lodash')

class SpectrumCanvasView
  BAR_WIDTH: 4

  constructor: (canvasId: @canvasId, analyser: @analyser, imagePath: imagePath) ->
    @canvas = document.querySelector(@canvasId)
    @buffer = new Uint8Array(@analyser.frequencyBinCount)
    @ctx = @canvas.getContext("2d")
    @image = new Image()
    @image.src = imagePath

  start: ->
    @ctx.clearRect(0, 0, @canvas.width, @canvas.height)
    @analyser.getByteFrequencyData(@buffer)
    len = @buffer.length
    for i in [0..len-1] by 4
      x = (i / len) * @canvas.width
      y = (1 - (@buffer[i] / 255)) * @canvas.height
      @ctx.drawImage(
        @image,
        0, y, @BAR_WIDTH, @canvas.height - y,
        x, y, @BAR_WIDTH, @canvas.height - y,
      )
    @req = requestAnimationFrame(_.bind(@start, @))

  stop: ->
    cancelAnimationFrame(@req)

module.exports = SpectrumCanvasView
