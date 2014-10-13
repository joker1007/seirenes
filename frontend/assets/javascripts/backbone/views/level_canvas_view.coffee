_ = require('lodash')

class LevelCanvasView
  constructor: (canvasId: @canvasId, analyser: @analyser) ->
    @canvas = document.querySelector(@canvasId)
    @buffer = new Uint8Array(@analyser.fftSize)
    @bufferSize = @analyser.fftSize

    @ctx = @canvas.getContext("2d")
    @ctx.lineWidth = 0.5
    @ctx.strokeStyle = "rgb(240, 240, 240)"

    @ctx.fillStyle = @grad()

    @counter = 0

    @renderInit()

  # Not Imple
  grad: ->

  start: ->
    @analyser.getByteTimeDomainData(@buffer)

    signals = @getAvgSignals(@buffer, 8)

    for s in signals
      @renderSignal(s)

    # @renderSignal(@buffer[0])
    # @renderSignal(@buffer[@bufferSize / 4 * 1])
    # @renderSignal(@buffer[@bufferSize / 4 * 2])
    # @renderSignal(@buffer[@bufferSize / 4 * 3])
    # @renderSignal(@buffer[Math.max(@bufferSize / 4 * 4, @bufferSize)])
    @req = requestAnimationFrame(_.bind(@start, @))

  getAvgSignals: (buffer, partitionSize) ->
    result = []
    len = buffer.length

    for i in [0..partitionSize-1]
      sumSignal = 0
      from = i * len / partitionSize
      to = (i + 1) * len / partitionSize - 1
      for i in [from..to]
        sumSignal += @buffer[i]
      result.push(sumSignal / (len / partitionSize))

    result

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

    delta = Math.abs(signal - 128)
    @ctx.fillRect(@counter, @canvas.height / 2 - delta, 1, delta * 2 + 1)
    @counter += 0.1
    @

  reset: ->
    @counter = 0
    @ctx.clearRect(0, 0, @canvas.width, @canvas.height)
    @renderInit()
    @

class MusicLevelCanvasView extends LevelCanvasView
  grad: ->
    grad = @ctx.createLinearGradient(0, 0, 0, 256)
    grad.addColorStop(0, "rgb(80,200,255)")
    grad.addColorStop(0.5, "rgb(0,171,255)")
    grad.addColorStop(1, "rgb(80,200,255)")
    grad

class MicLevelCanvasView extends LevelCanvasView
  grad: ->
    grad = @ctx.createLinearGradient(0, 0, 0, 256)
    grad.addColorStop(0, "rgb(255,150,155)")
    grad.addColorStop(0.5, "rgb(255,134,0)")
    grad.addColorStop(1, "rgb(255,150,155)")
    grad

module.exports =
  MusicLevelCanvasView: MusicLevelCanvasView
  MicLevelCanvasView: MicLevelCanvasView
