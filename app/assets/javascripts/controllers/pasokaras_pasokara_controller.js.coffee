Seirenes.PasokarasPasokaraController = Ember.ObjectController.extend
  createRecorder: (video) ->
    @set("recorder", Seirenes.Recorder.create(video: video))

  startRecord: ->
    @createRecorder(document.querySelector("video")) unless @get("recorder")
    @get("recorder").record()

  stopRecord: ->
    @get("recorder").stopRecord (audioData) =>
      @set("recordAudioUrl", webkitURL.createObjectURL(audioData))

  upload: ->
    $dummyForm = $(document.createElement("form"))
    $dummyForm.fileupload
      dataType: 'json'
      url: "/pasokaras/#{@get("content").id}/recordings"
      maxChunkSize: 1048576
      done: (e, data) ->
        jQuery.gritter.add
          image: "#{gritter_success_image_path}"
          title: 'Success'
          text: "アップロードが成功しました"
      fail: (e, data) ->
        jQuery.gritter.add
          image: "#{gritter_error_image_path}"
          title: 'Error'
          text: "アップロードに失敗しました。#{data}"
    $dummyForm.fileupload('send', {files: @get("recorder").get("audioData")})
