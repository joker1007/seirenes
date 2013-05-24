Seirenes.PasokarasPasokaraController = Ember.ObjectController.extend
  createRecorder: (video) ->
    @set("recorder", Seirenes.Recorder.create(video: video))

  startRecord: ->
    @createRecorder(document.querySelector("video")) unless @get("recorder")
    @get("recorder").record()

  stopRecord: ->
    @get("recorder").stopRecord (audioData) =>
      @set("recordAudioUrl", webkitURL.createObjectURL(audioData))
