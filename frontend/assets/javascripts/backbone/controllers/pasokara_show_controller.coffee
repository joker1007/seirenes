Seirenes = require('../app')
Vue = require('vue')
Vue.component('preview_video_player', require('../templates/preview_video_player.vue'))
_ = require('lodash')

Pasokara = require('../models/pasokara')
EncodingStatus = require('../models/encoding_status')

module.exports = Seirenes.module "PasokaraShowController", (PasokaraShowController, App, Backbone, Marionette, $, _) ->
  @startWithParent = false

  APIBase = Marionette.Controller.extend
    show: (id) ->
      @pasokara = new Pasokara(id: id)
      @pasokara.fetch().done =>
        data = @pasokara.toJSON()
        encodingStatus = new EncodingStatus(id: @pasokara.id)
        data.encoding = not data.movie_url?
        data.encodingProgress = 0
        @listenTo encodingStatus, "change:progress", ->
          data.encodingProgress = encodingStatus.get("progress")
        @listenTo encodingStatus, "encoded", (url) ->
          data.encoding = false
          data.movie_url = url
        encodingStatus.encode()

        pasokaraShowVueOptions = require('../templates/pasokara_show.vue')
        pasokaraShowVueOptions.data = data
        @pasokaraShowVM = new Vue(pasokaraShowVueOptions)
        @pasokaraShowVM.$appendTo('#main-contents')
        @pasokaraShowVM.$.preview_video_player.$data = data

  @addInitializer ->
    controller = new APIBase()
    @API = controller

  @addFinalizer ->
    @API.pasokaraShowVM.$destroy()
    @API.destroy()

  PasokaraShowController
