Seirenes.module "Views", (Views, App, Backbone, Marionette, $, _) ->
  Views.RecordedModal = Marionette.ItemView.extend
    template: "backbone/templates/recorded_modal"
    className: 'modal fade'

    events:
      "click #play-recorded": "play"
      "click #stop-recorded": "stop"
      "click #rendering": "renderingRecorded"
      "change #music-delay-field": "setMusicDelay"
      "keyup #music-delay-field": "setMusicDelay"
      "change #mic-delay-field": "setMicDelay"
      "keyup #mic-delay-field": "setMicDelay"

    onRender: ->
      @$el.modal({backdrop: true})
      @$el.on 'hidden.bs.modal', =>
        @destroy()

      @audioSetup()

    audioSetup: ->
      @context = new AudioContext()
      @musicEl = @$("#music-audio")[0]
      @micEl = @$("#mic-audio")[0]
      @music = @context.createMediaElementSource(@musicEl)
      @mic = @context.createMediaElementSource(@micEl)

      @musicDelay = @context.createDelay()
      @musicPeaking = @context.createBiquadFilter()
      @musicPeaking.type = "peaking"
      @musicPeaking.Q.value = 0
      @musicPeaking.gain.value = 0

      @music.connect(@musicDelay)
      @musicDelay.connect(@musicPeaking)
      @musicPeaking.connect(@context.destination)

      @micDelay = @context.createDelay()
      @micPeaking = @context.createBiquadFilter()
      @micPeaking.type = "peaking"
      @micPeaking.Q.value = 0
      @micPeaking.gain.value = 0

      @mic.connect(@micDelay)
      @micDelay.connect(@micPeaking)
      @micPeaking.connect(@context.destination)

    play: ->
      @musicEl.currentTime = 0
      @micEl.currentTime = 0
      @musicEl.play()
      @micEl.play()

    stop: ->
      @musicEl.pause()
      @micEl.pause()
      @musicEl.currentTime = 0
      @micEl.currentTime = 0

    setMusicDelay: (e) ->
      @musicDelay.delayTime.value = parseFloat($(e.target).val())

    setMicDelay: (e) ->
      @musicDelay.delayTime.value = parseFloat($(e.target).val())

    renderingRecorded: ->
      @offlineContext = new OfflineAudioContext(2, @model.get("frameLength"), @model.get("sampleRate"))
      fileReader = new FileReader()
      fileReader.onload = (e) =>
        arrayBuffer = e.target.result
        @offlineContext.decodeAudioData arrayBuffer, (buf) =>
          bufferSource = @offlineContext.createBufferSource()
          bufferSource.buffer = buf
          bufferSource.connect(@offlineContext.destination)

          @offlineContext.oncomplete = (e) =>
            rendered = e.renderedBuffer
            exported = @exportWAV("audio/wav", rendered.getChannelData(0), rendered.getChannelData(1))
            audio = $("<audio>")
              .attr("src", webkitURL.createObjectURL(exported))
              .attr("controls", "controls")
            @$(".modal-body").append(audio)

          bufferSource.start()
          @offlineContext.startRendering()

      fileReader.readAsArrayBuffer(@model.get("musicBlob"))
  
    exportWAV: (type, bufferL, bufferR) ->
      interleaved = @interleave(bufferL, bufferR)
      dataview = @encodeWAV(interleaved)
      new Blob([dataview], { type: type })

    interleave: (inputL, inputR) ->
      length = inputL.length + inputR.length
      result = new Float32Array(length)

      index = 0
      inputIndex = 0

      while (index < length)
        result[index++] = inputL[inputIndex]
        result[index++] = inputR[inputIndex]
        inputIndex++

      result

    floatTo16BitPCM: (output, offset, input) ->
      for i in [0..(input.length - 1)]
        s = Math.max(-1, Math.min(1, input[i]))
        output.setInt16(offset, s < 0 ? s * 0x8000 : s * 0x7FFF, true)
        offset += 2

    writeString: (view, offset, string) ->
      for i in [0..(string.length - 1)]
        view.setUint8(offset + i, string.charCodeAt(i))

    encodeWAV: (samples) ->
      buffer = new ArrayBuffer(44 + samples.length * 2)
      view = new DataView(buffer)

      # RIFF identifier */
      @writeString(view, 0, 'RIFF')
      # file length */
      view.setUint32(4, 32 + samples.length * 2, true)
      # RIFF type */
      @writeString(view, 8, 'WAVE')
      # format chunk identifier */
      @writeString(view, 12, 'fmt ')
      # format chunk length */
      view.setUint32(16, 16, true)
      # sample format (raw) */
      view.setUint16(20, 1, true)
      # channel count */
      view.setUint16(22, 2, true)
      # sample rate */
      view.setUint32(24, @model.get("sampleRate"), true)
      # byte rate (sample rate * block align) */
      view.setUint32(28, @model.get("sampleRate") * 4, true)
      # block align (channel count * bytes per sample) */
      view.setUint16(32, 4, true)
      # bits per sample */
      view.setUint16(34, 16, true)
      # data chunk identifier */
      @writeString(view, 36, 'data')
      # data chunk length */
      view.setUint32(40, samples.length * 2, true)

      @floatTo16BitPCM(view, 44, samples)

      view
