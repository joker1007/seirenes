Seirenes.Router.map (match)->
  @resource('pasokaras', ->
    @route("list")
    @route("pasokara", {path: '/:pasokara_id'})
  )
  @resource('song_queues', ->
    @route("list")
  )
  @route("player")
  # match('/').to('index')

