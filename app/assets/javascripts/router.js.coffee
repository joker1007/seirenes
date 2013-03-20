Seirenes.Router.map (match)->
  @resource('pasokaras', ->
    @route("list")
  )
  @resource('pasokara', {path: '/pasokaras/:pasokara_id'})
  # match('/').to('index')

