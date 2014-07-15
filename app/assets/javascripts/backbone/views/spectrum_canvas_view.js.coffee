#= require ../app

Seirenes.module "Views", (Views, App, Backbone, Marionette, $, _) ->
  Views.SpectrumCanvasView = Marionette.View.extend
    BAR_WIDTH: 5

    initialize:(canvas: @canvas, analyzer: @analyzer, imagePath: imagePath) ->
      @buffer = new Uint8Array(@analyzer.frequencyBinCount / 4)
      @ctx = @canvas.getContext("2d")
      @image = new Image()
      @image.src = imagePath

    start: ->
      @ctx.clearRect(0, 0, @canvas.width, @canvas.height)
      @analyzer.getByteFrequencyData(@buffer)
      len = @buffer.length
      for i in [0..len-1]
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
