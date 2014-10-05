#= require ../app

Seirenes.module "Models", (Models, App, Backbone, Marionette, $, _) ->
  Models.Recorder = Backbone.Model.extend
    musicDelayTime: 0.018

    initialize: ({video: @video, monitor: @monitor}) ->
      @context = new AudioContext()
      @music = @context.createMediaElementSource(@video)
      throw new Error("no video") unless @video

    addRecordTrack: ->
      navigator.getUserMedia({audio: true}, _.bind(@__assignRecordTrack, @), _.bind(@captureFail, @))

    __assignRecordTrack: (s) ->
      @micStream = s
      @mic = @context.createMediaStreamSource(s)

    record: ->
      # ビデオとマイクのミキサー
      @mixer = @context.createGain()

      # マイクのゲイン
      @micGain = @context.createGain()

      splitter = @context.createChannelSplitter()

      # ノイズ除去のため低音域をカット
      highpassFilter = @context.createBiquadFilter()
      highpassFilter.type = "highpass"
      highpassFilter.frequency.value = 80 # hz
      highpassFilter.Q.value = 0

      # マイク音量の底上げ
      peaking = @context.createBiquadFilter()
      peaking.type = "peaking"
      peaking.Q.value = 0 # All frequency
      peaking.gain.value = 2.5 # db

      # サシスセソ領域の音を減衰させる
      deesser = @context.createBiquadFilter()
      deesser.type = "peaking"
      deesser.frequency.value = 6000
      deesser.Q.value = 5
      deesser.gain.value = -3

      micAnalyser = @context.createAnalyser()
      micAnalyser.fftSize = 256

      @mic.connect(splitter)
      splitter.connect(highpassFilter, 0)
      highpassFilter.connect(peaking)
      peaking.connect(deesser)
      deesser.connect(micAnalyser)

      compressor = new Models.VocalCompressor(source: deesser)
      delayEffector = new Models.DelayEffector(source: compressor.output)
      delayEffector.output.connect(@micGain)
      @micGain.connect(@mixer)

      musicDelay = @context.createDelay()
      musicDelay.delayTime.value = @musicDelayTime
      @music.connect(musicDelay)

      musicDelay.connect(@mixer)

      musicAnalyser = @context.createAnalyser()
      musicAnalyser.fftSize = 256
      @music.connect(musicAnalyser)
      @music.connect(@context.destination)

      # 高音域を軽くブーストする
      trebleBoost = @context.createBiquadFilter()
      trebleBoost.type = "highshelf"
      trebleBoost.frequency.value = 14000 # hz
      trebleBoost.gain.value = 3

      # Mix後のコンプレッサー
      dynamicsCompressor = @context.createDynamicsCompressor()
      dynamicsCompressor.threshold.value = -20

      # Mix後のピーキング
      mixPeaking = @context.createBiquadFilter()
      mixPeaking.type = "peaking"
      mixPeaking.Q.value = 0 # All frequency
      mixPeaking.gain.value = 2 # db

      @mixer.connect(trebleBoost)
      trebleBoost.connect(dynamicsCompressor)
      dynamicsCompressor.connect(mixPeaking)

      @recorder = new Recorder(mixPeaking, {workerPath: RECORDER_WORKER_PATH})
      dummy = @context.createGain()
      dummy.gain.value = 0
      @recorder.node.connect(dummy)

      @recorder.record()
      @video.currentTime = 0
      @video.play()

      @musicLevelCanvasView = new App.Views.MusicLevelCanvasView(canvas: document.getElementById("music-level"), analyzer: musicAnalyser)
      @micLevelCanvasView = new App.Views.MicLevelCanvasView(canvas: document.getElementById("mic-level"), analyzer: micAnalyser)

      @musicSpectrumCanvasView = new App.Views.SpectrumCanvasView(canvas: document.getElementById("music-spectrum"), analyzer: musicAnalyser, imagePath: "/assets/spectrum-music.png")
      @micSpectrumCanvasView = new App.Views.SpectrumCanvasView(canvas: document.getElementById("mic-spectrum"), analyzer: micAnalyser, imagePath: "/assets/spectrum-mic.png")

      @musicLevelCanvasView.start()
      @micLevelCanvasView.start()
      @musicSpectrumCanvasView.start()
      @micSpectrumCanvasView.start()

    captureFail: (s) ->
      alert("マイクが利用できません")

    stopRecord: (callback) ->
      @video.pause()
      @video.currentTime = 0
      clearInterval(@timer)
      @musicLevelCanvasView.stop()
      @micLevelCanvasView.stop()
      @musicSpectrumCanvasView.stop()
      @micSpectrumCanvasView.stop()
      @recorder.stop()
      @micStream.stop()
      @recorder.exportWAV (blob) =>
        @audioData = blob
        if callback
          callback(blob)
