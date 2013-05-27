if window.webkitAudioContext
  Seirenes.Recorder = Ember.Object.extend
    context: new webkitAudioContext()
    musicGainValue: 0.8

    init: ->
      @_super()
      throw new Error("no video") unless @get("video")
      @set("mixer", @get("context").createGain())
      @set("musicGain", @get("context").createGain())
      @get("musicGain").gain.value = @get("musicGainValue")

      @set("elementMediaSource", @get("context").createMediaElementSource(@get("video")))
      @get("elementMediaSource").connect(@get("musicGain"))
      @get("elementMediaSource").connect(@get("context").destination)
      @get("musicGain").connect(@get("mixer"))

    record: ->
      that = this
      captureSuccess = (s) ->
        that.set("micStream", s)
        that.set("mediaStreamSource", that.get("context").createMediaStreamSource(s))
        compressor = Seirenes.VocalCompressor.create(source: that.get("mediaStreamSource"))
        delayEffector = Seirenes.DelayEffector.create(source: compressor.get("output"))
        delayEffector.get("output").connect(that.get("mixer"))
        that.set("recorder", new Recorder(that.get("mixer"), {workerPath: RECORDER_WORKER_PATH}))
        dummy = that.get("context").createGain()
        dummy.gain.value = 0
        that.get("recorder").node.connect(dummy)
        that.get("recorder").record()
        that.get("video").currentTime = 0
        that.get("video").play()
      captureFail = (s) ->
        alert("マイクが利用できません")

      navigator.getUserMedia({audio: true}, captureSuccess, captureFail)

    stopRecord: (callback) ->
      @get("video").pause()
      @get("video").currentTime = 0
      @get("recorder").stop()
      @get("micStream").stop()
      @get("recorder").exportWAV (blob) =>
        @set("audioData", blob)
        if callback
          callback(blob)

