Seirenes.Router.map (match)->
  @resource('pasokaras', ->
    @route("list")
    @route("pasokara", {path: '/:pasokara_id'})
  )
  @resource('song_queues', ->
    @route("list")
  )
  @resource('histories', ->
    @route("list")
  )
  @resource('favorites', ->
    @route("list")
  )
  @resource('recordings', ->
    @route("list")
  )
  @route("player")
  # match('/').to('index')

Seirenes.Router.reopen
  location: "query"
