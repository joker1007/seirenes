if window.webkitAudioContext
  Seirenes.Recorder = Ember.Object.extend
    context: new webkitAudioContext()
    musicGainValue: 1.0
    musicDelayTime: 0.005

    init: ->
      @_super()
      throw new Error("no video") unless @get("video")
      @set("mixer", @get("context").createGain())
      @set("musicGain", @get("context").createGain())
      @get("musicGain").gain.value = @get("musicGainValue")

      @set("elementMediaSource", @get("context").createMediaElementSource(@get("video")))
      @get("elementMediaSource").connect(@get("musicGain"))
      @get("elementMediaSource").connect(@get("context").destination)
      musicDelay = @get("context").createDelay()
      musicDelay.delayTime.value = @get("musicDelayTime")
      @get("musicGain").connect(musicDelay)
      musicDelay.connect(@get("mixer"))

    record: ->
      that = this
      captureSuccess = (s) ->
        that.set("micStream", s)
        that.set("mediaStreamSource", that.get("context").createMediaStreamSource(s))

        splitter = that.get("context").createChannelSplitter()

        # ノイズ除去のため低音域をカット
        highpassFilter = that.get("context").createBiquadFilter()
        highpassFilter.type = "highpass"
        highpassFilter.frequency.value = 80 # hz
        highpassFilter.Q.value = 0

        # マイク音量の底上げ
        peaking = that.get("context").createBiquadFilter()
        peaking.type = "peaking"
        peaking.Q.value = 0 # All frequency
        peaking.gain.value = 2 # db

        # サシスセソ領域の音を減衰させる
        deesser = that.get("context").createBiquadFilter()
        deesser.type = "peaking"
        deesser.frequency.value = 6000
        deesser.Q.value = 5
        deesser.gain.value = -3

        # 高音域を軽くブーストする
        trebleBoost = that.get("context").createBiquadFilter()
        trebleBoost.type = "highshelf"
        trebleBoost.frequency.value = 14000 # hz
        trebleBoost.gain.value = 3

        # Mix後のコンプレッサー
        dynamicsCompressor = that.get("context").createDynamicsCompressor()

        that.get("mediaStreamSource").connect(splitter)
        splitter.connect(highpassFilter, 0)
        highpassFilter.connect(peaking)
        peaking.connect(deesser)

        compressor = Seirenes.VocalCompressor.create(source: deesser)
        delayEffector = Seirenes.DelayEffector.create(source: compressor.get("output"))
        delayEffector.get("output").connect(that.get("mixer"))
        delayEffector.get("output").connect(that.get("context").destination) if that.get("monitor")

        that.get("mixer").connect(trebleBoost)
        trebleBoost.connect(dynamicsCompressor)

        that.set("recorder", new Recorder(dynamicsCompressor, {workerPath: RECORDER_WORKER_PATH}))
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

