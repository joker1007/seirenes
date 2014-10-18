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
        data: {playing: {}}
      playingVM.$appendTo('#playing')

      videoPlayerVueOptions = require('../templates/video_player.vue')
      _.extend videoPlayerVueOptions,
        data: playingVM.$data
      videoPlayerVM = new Vue(videoPlayerVueOptions)
      videoPlayerVM.$appendTo('#video-area')

      queryVM = @__buildQueryVM()

      @listenTo @songQueues, 'sync', =>
        songQueuesData = @songQueues.toJSON()
        if songQueuesData.length < 2 && queryVM
          SongQueue.createRandom(queryVM.q)

        songQueuesVM.$set('items', songQueuesData)

        return if playingVM.playing?.id?
        return if _.isEmpty(songQueuesData)

        playingVM.playing = songQueuesData[0]

        encodingStatus = new EncodingStatus(id: playingVM.playing.pasokara_id)
        encodingStatus.on "encoded", (url) ->
          playingVM.playing.movie_url = url
        encodingStatus.periodicallyCheck()

    __buildQueryVM: ->
      if document.querySelector("#query_for_random")
        new Vue
          el: "#query_for_random"
          data: {q: 'onvocal OR "on vocal"'}
      else
        null

    startLoop: ->
      @songQueues.startFetchLoop(5000)

    stopLoop: ->
      @songQueues.stopFetchLoop()

  @addInitializer ->
    controller = new APIBase()
    @API = controller

  @on "start", ->
    @API.startLoop()

  @on "stop", ->
    @API.stopLoop()

  PlayerController
