#= require ../app

Seirenes.module "Views", (Views, App, Backbone, Marionette, $, _) ->
  Views.LevelCanvasView = Marionette.View.extend
    initialize:(canvas: @canvas, analyzer: @analyzer) ->
      @buffer = new Uint8Array(@analyzer.fftSize)
      @bufferSize = @analyzer.fftSize

      @ctx = @canvas.getContext("2d")
      @ctx.lineWidth = 1
      @ctx.strokeStyle = "rgb(240, 240, 240)"

      @ctx.fillStyle = @grad()

      @counter = 0
      @signalBuffer = []

      @renderInit()

    # Not Imple
    grad: ->

    start: ->
      @analyzer.getByteTimeDomainData(@buffer)
      @renderSignal(@buffer[0])
      @signalBuffer.push(@buffer[0])
      @renderSignal(@buffer[@bufferSize / 4 * 1])
      @signalBuffer.push(@buffer[@bufferSize / 4 * 1])
      @renderSignal(@buffer[@bufferSize / 4 * 2])
      @signalBuffer.push(@buffer[@bufferSize / 4 * 2])
      @renderSignal(@buffer[@bufferSize / 4 * 3])
      @signalBuffer.push(@buffer[@bufferSize / 4 * 3])
      @req = requestAnimationFrame(_.bind(@start, @))

    stop: ->
      cancelAnimationFrame(@req)

    renderInit: ->
      @ctx.beginPath()
      @ctx.moveTo(0, @canvas.height / 2)
      @ctx.lineTo(@canvas.width, @canvas.height / 2)
      @ctx.closePath()
      @ctx.stroke()
      @

    renderSignal: (signal) ->
      if @counter >= @canvas.width
        @reset()
      delta = Math.abs(signal - @canvas.height / 2)
      @ctx.fillRect(@counter, @canvas.height / 2 - delta, 1, delta * 2 + 1)
      @counter += 0.1
      @

    reset: ->
      @counter = 0
      @ctx.clearRect(0, 0, @canvas.width, @canvas.height)
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
