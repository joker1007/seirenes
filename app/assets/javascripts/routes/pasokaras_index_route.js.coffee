Seirenes.PasokarasIndexRoute = Ember.Route.extend
  model: ->
    Seirenes.Pasokara.find()

  setupController: (controller, model) ->
    facet_tags = Seirenes.FacetTag.find()
    @controllerFor('facet_tags').set('content', facet_tags)
    controller.set('content', model)

