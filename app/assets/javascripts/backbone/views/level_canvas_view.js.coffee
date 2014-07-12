#= require ../app

Seirenes.module "Views", (Views, App, Backbone, Marionette, $, _) ->
  Views.LevelCanvasView = Marionette.View.extend
    WIDTH: 350
    HEIGHT: 256

    initialize:(canvas: @canvas, analyzer: @analyzer) ->
      @buffer = new Uint8Array(@analyzer.fftSize)

      @ctx = @canvas.getContext("2d")
      @ctx.lineWidth = 1
      @ctx.strokeStyle = "rgb(220, 220, 220)"

      @ctx.fillStyle = @grad()

      @counter = 0

      @renderInit()

    # Not Imple
    grad: ->

    start: ->
      @updateCanvas()

    stop: ->
      cancelAnimationFrame(@req)

    updateCanvas: ->
      @analyzer.getByteTimeDomainData(@buffer)
      @renderSignal(@buffer[0])
      @req = requestAnimationFrame(_.bind(@updateCanvas, @))

    renderInit: ->
      @ctx.beginPath()
      @ctx.moveTo(0, @HEIGHT / 2)
      @ctx.lineTo(@WIDTH, @HEIGHT / 2)
      @ctx.closePath()
      @ctx.stroke()
      @

    renderSignal: (signal) ->
      if @counter >= @WIDTH
        @reset()
      delta = Math.abs(signal - @HEIGHT / 2)
      @ctx.fillRect(@counter, @HEIGHT / 2 - delta, 1, delta * 2 + 1)
      @counter += 0.5
      @

    reset: ->
      @counter = 0
      @ctx.clearRect(0, 0, @WIDTH, @HEIGHT)
      @renderInit()
      @

  Views.MusicLevelCanvasView = Views.LevelCanvasView.extend
    grad: ->
      grad = @ctx.createLinearGradient(0, 0, 0, 256)
      grad.addColorStop(0, "rgb(80,200,255)")
      grad.addColorStop(0.5, "rgb(0,171,255)")
      grad.addColorStop(1, "rgb(80,200,255)")
      grad

  Views.MicLevelCanvasView = Views.LevelCanvasView.extend
    grad: ->
      grad = @ctx.createLinearGradient(0, 0, 0, 256)
      grad.addColorStop(0, "rgb(255,150,155)")
      grad.addColorStop(0.5, "rgb(255,134,0)")
      grad.addColorStop(1, "rgb(255,150,155)")
      grad
