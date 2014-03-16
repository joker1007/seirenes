#= require ../app

Seirenes.module "Models", (Models, App, Backbone, Marionette, $, _) ->
  Models.Player = Backbone.Model.extend
    initialize: ({songQueues: @songQueues}) ->
      @set(playing: null)
      @listenTo @songQueues, "sync", _.bind(@pickup, @)

    pickup: ->
      if @get("playing") == null && !@songQueues.isEmpty()
        @set(playing: @songQueues.at(0))
        encodingStatus = new Models.EncodingStatus(id: @get("playing").get("pasokara_id"))
        encodingStatus.on "encoded", (url) =>
          @get("playing").set(movie_url: url)
        encodingStatus.periodicallyCheck()
