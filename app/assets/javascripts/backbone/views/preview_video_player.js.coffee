Seirenes.module "Views", (Views, App, Backbone, Marionette, $, _) ->
  Views.PreviewVideoPlayer = Marionette.ItemView.extend
    template: "backbone/templates/preview_video_player"

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

    onRender: ->
      @stickit()
