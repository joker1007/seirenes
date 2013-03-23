Seirenes.Router.map (match)->
  @resource('pasokaras', ->
    @route("list")
    @route("pasokara", {path: '/:pasokara_id'})
  )
  # match('/').to('index')

