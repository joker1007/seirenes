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
      micAnalyser.maxDecibels = -40

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
      musicAnalyser.maxDecibels = -40
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

      musicLevelCanvas = document.getElementById("music-level")
      ctx = musicLevelCanvas.getContext("2d")
      ctx.lineWidth = 0.5
      ctx.strokeStyle = "rgb(220, 220, 220)"
      ctx.beginPath()
      ctx.moveTo(0, 128)
      ctx.lineTo(350, 128)
      ctx.closePath()
      ctx.stroke()
      grad = ctx.createLinearGradient(0, 0, 0, 256)
      grad.addColorStop(0, "rgb(0,171,255)")

      micLevelCanvas = document.getElementById("mic-level")
      ctx2 = micLevelCanvas.getContext("2d")
      ctx2.lineWidth = 0.5
      ctx2.strokeStyle = "rgb(220, 220, 220)"
      ctx2.beginPath()
      ctx2.moveTo(0, 128)
      ctx2.lineTo(350, 128)
      ctx2.closePath()
      ctx2.stroke()
      grad2 = ctx.createLinearGradient(0, 0, 0, 256)
      grad2.addColorStop(0, "rgb(255,134,0)")

      musicSpectrumCanvas = document.getElementById("music-spectrum")
      musicSpectrum = new Models.Spectrum()
      musicSpectrum.setChartImage("/assets/spectrum-music.png")
      micSpectrumCanvas = document.getElementById("mic-spectrum")
      micSpectrum = new Models.Spectrum()
      micSpectrum.setChartImage("/assets/spectrum-mic.png")

      start = 0
      @timer = setInterval ->
        musicData = new Uint8Array(musicAnalyser.fftSize)
        micData = new Uint8Array(micAnalyser.fftSize)
        musicFreq = new Uint8Array(musicAnalyser.frequencyBinCount)
        micFreq = new Uint8Array(micAnalyser.frequencyBinCount)
        musicAnalyser.getByteTimeDomainData(musicData)
        micAnalyser.getByteTimeDomainData(micData)
        musicAnalyser.getByteFrequencyData(musicFreq)
        micAnalyser.getByteFrequencyData(micFreq)

        musicSpectrum.draw(musicSpectrumCanvas, musicFreq)
        micSpectrum.draw(micSpectrumCanvas, micFreq)

        musicSignal = musicData[0]
        micSignal = micData[0]
        musicDelta = Math.abs(musicSignal - 128)
        micDelta = Math.abs(micSignal - 128)

        ctx.fillStyle = grad
        ctx2.fillStyle = grad2
        ctx.fillRect(start, 128 - musicDelta, 1, musicDelta * 2 + 1)
        ctx2.fillRect(start, 128 - micDelta, 1, micDelta * 2 + 1)
        start += 0.5
        if start >= 350
          start = 0
          ctx.clearRect(0, 0, musicLevelCanvas.width, musicLevelCanvas.height)
          ctx.beginPath()
          ctx.moveTo(0, 128)
          ctx.lineTo(350, 128)
          ctx.closePath()
          ctx.stroke()
          ctx2.clearRect(0, 0, micLevelCanvas.width, micLevelCanvas.height)
          ctx2.beginPath()
          ctx2.moveTo(0, 128)
          ctx2.lineTo(350, 128)
          ctx2.closePath()
          ctx2.stroke()
      , 50

    captureFail: (s) ->
      alert("マイクが利用できません")

    stopRecord: (callback) ->
      @video.pause()
      @video.currentTime = 0
      clearInterval(@timer)
      @recorder.stop()
      @micStream.stop()
      @recorder.exportWAV (blob) =>
        @audioData = blob
        if callback
          callback(blob)
