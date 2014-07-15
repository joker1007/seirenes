Seirenes.module "Views", (Views, App, Backbone, Marionette, $, _) ->
  Views.PreviewVideoPlayer = Marionette.ItemView.extend
    template: "backbone/templates/preview_video_player"

    events:
      "click .js-add_rec": "addRecordTrack"
      "click .js-start_rec": "startRecord"
      "click .js-stop_rec": "stopRecord"
      "click .js-upload" : "uploadRecordedData"

    bindings:
      "#pasokara-preview":
        observe: "movie_url"
        update: ($el, val, model, options) ->
          if val? && val != ""
            $video = $(document.createElement("video"))
            $video.addClass("preview")
              .attr("id", "preview-player")
              .attr("controls", "controls")
              .attr("src", val)
            $el.html($video)
          else
            encodingStatusView = new Views.EncodingStatusView(model: model.encodingStatus)
            $el.html(encodingStatusView.render().el) # TODO: インジケーター
      "#recorded":
        observe: "recordedDataUrl"
        update: ($el, val, model, options) ->
          if val? && val != ""
            $audio = $(document.createElement("audio"))
            $audio.addClass("player")
              .attr("id", "recorded-player")
              .attr("controls", "controls")
              .attr("src", val)
            $el.html($audio)
            $button = $(document.createElement("button"))
            $button.addClass("js-upload").text("Upload")
            $el.append($button)

    onRender: ->
      @stickit()

    addRecordTrack: ->
      @recorder = new App.Models.Recorder(video: @$("video")[0])
      @recorder.addRecordTrack()

    startRecord: ->
      @recorder.record()

    stopRecord: ->
      @recorder.stopRecord (audioData) =>
        @model.set("recordedData", audioData)
        @model.set("recordedDataUrl", webkitURL.createObjectURL(audioData))

    uploadRecordedData: ->
      @model.uploadRecordedData()
