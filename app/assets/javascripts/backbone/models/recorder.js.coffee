#= require ../app

Seirenes.module "Models", (Models, App, Backbone, Marionette, $, _) ->
  Models.Recorder = Backbone.Model.extend
    musicDelayTime: 0.018

    initialize: ({video: @video, monitor: @monitor}) ->
      @context = new AudioContext()
      @music = @context.createMediaElementSource(@video)
      @music.connect(@context.destination)
      throw new Error("no video") unless @video

    addRecordTrack: ->
      navigator.getUserMedia({audio: true}, _.bind(@__assignRecordTrack, @), _.bind(@captureFail, @))

    __assignRecordTrack: (s) ->
      @micStream = s
      @mic = @context.createMediaStreamSource(s)

    record: ->
      micAnalyser = @context.createAnalyser()
      micAnalyser.fftSize = 256
      musicAnalyser = @context.createAnalyser()
      musicAnalyser.fftSize = 256

      @mic.connect(micAnalyser)
      @music.connect(musicAnalyser)

      @musicLevelCanvasView = new App.Views.MusicLevelCanvasView(canvas: document.getElementById("music-level"), analyzer: musicAnalyser)
      @micLevelCanvasView = new App.Views.MicLevelCanvasView(canvas: document.getElementById("mic-level"), analyzer: micAnalyser)

      @musicSpectrumCanvasView = new App.Views.SpectrumCanvasView(canvas: document.getElementById("music-spectrum"), analyzer: musicAnalyser, imagePath: "/assets/spectrum-music.png")
      @micSpectrumCanvasView = new App.Views.SpectrumCanvasView(canvas: document.getElementById("mic-spectrum"), analyzer: micAnalyser, imagePath: "/assets/spectrum-mic.png")

      @musicLevelCanvasView.start()
      @micLevelCanvasView.start()
      @musicSpectrumCanvasView.start()
      @micSpectrumCanvasView.start()

      @musicRecorder = new Recorder(@music, {workerPath: RECORDER_WORKER_PATH})
      @micRecorder = new Recorder(@mic, {workerPath: RECORDER_WORKER_PATH})
      dummy = @context.createGain()
      dummy.gain.value = 0
      @musicRecorder.node.connect(dummy)
      @micRecorder.node.connect(dummy)

      @musicRecorder.record()
      @micRecorder.record()

      @video.currentTime = 0
      @video.play()

    captureFail: (s) ->
      alert("マイクが利用できません")

    stopRecord: (callback) ->
      @video.pause()
      @video.currentTime = 0
      @musicLevelCanvasView.stop()
      @micLevelCanvasView.stop()
      @musicSpectrumCanvasView.stop()
      @micSpectrumCanvasView.stop()
      @micStream.stop()
      @musicRecorder.stop()
      @micRecorder.stop()
      p1 = new Promise (resolve, reject) =>
        @musicRecorder.exportWAV (blob) =>
          @musicAudioData = blob
          resolve
            blob: blob
            type: "music"
            frameLength: @musicRecorder.frameLength
            signalBuffer: @musicLevelCanvasView.signalBuffer
      p2 = new Promise (resolve, reject) =>
        @micRecorder.exportWAV (blob) =>
          @micAudioData = blob
          resolve
            blob: blob
            type: "mic"
            frameLength: @micRecorder.frameLength
            signalBuffer: @micLevelCanvasView.signalBuffer
      Promise.all([p1, p2]).then ([musicResult, micResult]) =>
        result = {
          musicBlob: musicResult.blob
          musicURL: webkitURL.createObjectURL(musicResult.blob)
          micBlob: micResult.blob
          micURL: webkitURL.createObjectURL(micResult.blob)
          frameLength: Math.max(musicResult.frameLength, micResult.frameLength)
          sampleRate: @context.sampleRate
        }
        callback(result)

