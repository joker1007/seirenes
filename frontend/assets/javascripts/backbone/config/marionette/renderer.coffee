do (Marionette) ->
  _.extend Marionette.Renderer,
    render: (template, data) ->
      if (!JST[template])
        throw "Template '#{template}' is not found"
      return JST[template](data)

