#= require ../app

Seirenes.module "PlayerController", (PlayerController, App, Backbone, Marionette, $, _) ->
  @startWithParent = false

  APIBase = Marionette.Controller.extend
    initialize: ->
      @playing = null
      @songQueues = new App.Models.SongQueueCollection()
      @player = new App.Models.Player(songQueues: @songQueues)
      @layout = new App.Layouts.PlayerLayout(el: $("body"))
      @songQueuesView = new App.Views.SongQueueCollectionView(collection: @songQueues)
      @layout.songQueueList.show(@songQueuesView)

      @playingView = new App.Views.PlayingView(model: @player)
      @layout.playing.show(@playingView)

      @videoPlayerView = new App.Views.VideoPlayerView(model: @player)
      @layout.videoArea.show(@videoPlayerView)

    startLoop: ->
      @songQueues.startFetchLoop(5000)

    stopLoop: ->
      @songQueuesFetchTimer.stopFetchLoop()

  @addInitializer ->
    controller = new APIBase()
    @API = controller

  @on "start", ->
    @API.startLoop()
