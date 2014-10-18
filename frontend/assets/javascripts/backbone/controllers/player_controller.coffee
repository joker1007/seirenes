Seirenes = require('../app')
Vue = require('vue')
Vue.component('song_queue_item', require('../templates/song_queue.vue'))

songQueueModule = require('../models/song_queue')
SongQueue = songQueueModule.SongQueue
SongQueueCollection = songQueueModule.SongQueueCollection

EncodingStatus = require('../models/encoding_status')

module.exports = Seirenes.module "PlayerController", (PlayerController, App, Backbone, Marionette, $, _) ->
  @startWithParent = false

  APIBase = Marionette.Controller.extend
    initialize: ->
      @songQueues = new SongQueueCollection()

      songQueueVueOptions = require('../templates/song_queue_collection.vue')
      songQueuesVM = new Vue(songQueueVueOptions)
      songQueuesVM.$appendTo('#song_queue-list')

      playingVM = new Vue
        template: '<div class="song_queue" v-component="song_queue_item" v-with="playing" v-if="playing.title"></div>'
        data:
          playing: {}
      playingVM.$appendTo('#playing')

      videoPlayerVueOptions = require('../templates/video_player.vue')
      _.extend videoPlayerVueOptions,
        data:
          playing: {}
        methods:
          ended: (e) ->
            new SongQueue(id: @playing.id, finish: true).save()
            setTimeout =>
              @$set('playing', {})
            , 2000
      videoPlayerVM = new Vue(videoPlayerVueOptions)
      videoPlayerVM.$appendTo('#video-area')

      @listenTo @songQueues, 'sync', =>
        songQueuesData = @songQueues.toJSON()
        songQueuesVM.$set('items', songQueuesData)

        return if playingVM.playing?.id?
        return if _.isEmpty(songQueuesData)

        playingVM.$data = {playing: songQueuesData[0]}
        videoPlayerVM.$data = playingVM.$data

        encodingStatus = new EncodingStatus(id: playingVM.playing.pasokara_id)
        encodingStatus.on "encoded", (url) =>
          playingVM.playing.movie_url = url
        encodingStatus.periodicallyCheck()

    startLoop: ->
      @songQueues.startFetchLoop(5000)

    stopLoop: ->
      @songQueuesFetchTimer.stopFetchLoop()

  @addInitializer ->
    controller = new APIBase()
    @API = controller

  @on "start", ->
    @API.startLoop()

  @on "stop", ->
    @API.stopLoop()

  PlayerController
