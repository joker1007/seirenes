#= require ../app

Seirenes.module "Models", (Models, App, Backbone, Marionette, $, _) ->
  Models.SongQueue = Backbone.Model.extend
    urlRoot: "/song_queues"

  Models.SongQueueCollection = Backbone.Collection.extend
    url: "/song_queues"
    model: Models.SongQueue

    startFetchLoop: (interval) ->
      @fetch(reset: true)
      @fetchLoopTimer = setTimeout =>
        @startFetchLoop(interval)
      , interval

    stopFetchLoop: ->
      clearTimeout(@fetchLoopTimer)
