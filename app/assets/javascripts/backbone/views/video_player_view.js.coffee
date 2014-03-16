#= require ../app

Seirenes.module "Views", (Views, App, Backbone, Marionette, $, _) ->
  Views.VideoPlayerView = Marionette.ItemView.extend
    template: "backbone/templates/video_player"

    initialize: ->
      @listenTo @model, "change:playing", (model, playing) =>
        @render()
        if playing?
          @listenTo playing, "change:movie_url", _.bind(@render, @)

    serializeData: ->
      @model.get("playing")?.toJSON()

    render: ->
      if @model.get("playing")?.get("movie_url")?
        Marionette.ItemView.prototype.render.apply(@, [])
      else
        @$el.html("")

    onRender: ->
      @$("video").on "ended", =>
        playing = @model.get("playing")
        playing.set(finish: true)
        playing.save()
        @model.set(playing: null)
