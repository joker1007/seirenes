Backbone = require('backbone')
EncodingStatus = require('./encoding_status')
_ = require('lodash')

Player = Backbone.Model.extend
  initialize: ({playing: @playing, songQueues: @songQueues}) ->
    @set(playing: null)
    @listenTo @songQueues, "sync", _.bind(@pickup, @)

  pickup: ->
    if @get("playing") == null && !@songQueues.isEmpty()
      @set(playing: @songQueues.at(0))

      encodingStatus = new EncodingStatus(id: @get("playing").get("pasokara_id"))
      encodingStatus.on "encoded", (url) =>
        @get("playing").set(movie_url: url)
      encodingStatus.periodicallyCheck()

module.exports = Player
