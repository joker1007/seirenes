#= require ../app

class Spectrum
  constructor: ->
    @chartImage = new Image()
    @barWidth = 3

  setChartImage: (imagePath) ->
    @chartImage.src = imagePath

  draw: (canvas, spectrums) ->
    context = canvas.getContext('2d')
    context.clearRect(0, 0, canvas.width, canvas.height)
    len = spectrums.length
    for i in [0..len-1]
      x = (i / len) * canvas.width
      y = (1 - (spectrums[i] / 255)) * canvas.height
      context.drawImage(
        @chartImage,
        0, y, @barWidth, canvas.height - y,
        x, y, @barWidth, canvas.height - y,
      )

Seirenes.module "Models", (Models, App, Backbone, Marionette, $, _) ->
  Models.Spectrum = Spectrum
