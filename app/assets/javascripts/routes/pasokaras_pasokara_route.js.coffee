Seirenes.PasokarasPasokaraRoute = Ember.Route.extend
  model: (params) ->
    pasokara = Seirenes.Pasokara.find(params.pasokara_id)

  setupController: (controller, model) ->
    controller.set('content', model)
    unless model.get("movieUrl")
      model.encode()
