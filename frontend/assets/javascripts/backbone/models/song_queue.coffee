$ = require('jquery')
Backbone = require('backbone')

SongQueue = Backbone.Model.extend
  urlRoot: "/song_queues"
,
  createRandom: (q = null) ->
    $.ajax "/song_queues/random",
      type: "POST"
      dataType: "json"
      contentType: "application/json"
      data: JSON.stringify(q: q)

SongQueueCollection = Backbone.Collection.extend
  url: "/song_queues"
  model: SongQueue

  startFetchLoop: (interval) ->
    @fetch(reset: true)
    @fetchLoopTimer = setTimeout =>
      @startFetchLoop(interval)
    , interval

  stopFetchLoop: ->
    clearTimeout(@fetchLoopTimer)


module.exports =
  SongQueue: SongQueue
  SongQueueCollection: SongQueueCollection
