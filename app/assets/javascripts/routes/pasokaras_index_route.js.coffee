Seirenes.PasokarasIndexRoute = Ember.Route.extend
  model: ->
    Seirenes.Pasokara.find()

  setupController: (controller, model) ->
    controller.set('content', model)

