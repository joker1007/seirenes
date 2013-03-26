Seirenes.PasokarasIndexRoute = Ember.Route.extend
  model: ->
    Seirenes.Pasokara.find({page: 2})

  setupController: (controller, model) ->
    controller.set("currentPage", model.get("meta").current_page)
    controller.set("totalPages", model.get("meta").total_pages)
    controller.set("perPage", model.get("meta").per_page)

    facet_tags_controller = @controllerFor('facetTags')
    facet_tags_controller.set('pasokarasIndexController', controller)
    unless facet_tags_controller.get('filterTags')
      facet_tags_controller.set('filterTags', [])
    else
      facet_tags_controller.get('filterTags').clear()
    facet_tags_controller.reload()

    controller.set('filterTags', [])
    controller.set('content', model)

  renderTemplate: ->
    facet_tags_controller = @controllerFor('facetTags')
    @render()
    @render('facetTags', {
      outlet: 'facetTags'
      controller: facet_tags_controller
    })

