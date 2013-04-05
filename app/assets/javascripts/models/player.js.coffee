Seirenes.player = Ember.Object.create
  playing: null

  startLoop: ->
    @fetchSongQueue()
    @timer = Ember.run.later(this, ->
      @timer = @startLoop()
    , 5000)

  stopLoop: ->
    Ember.run.cancel(@timer)

  fetchSongQueue: ->
    song_queues = Seirenes.SongQueue.find({})
    song_queues.on "didLoad", =>
      @set("playlist", song_queues.slice(1, 100))
      @set("playing", song_queues.get("firstObject"))

  pop: ->
    playing = @get("playing")
    @set("playing", null)
    playing.deleteRecord()
    playing.store.commit()
