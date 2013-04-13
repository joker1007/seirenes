Seirenes.PasokarasIndexRoute = Ember.Route.extend
  serializeParams: (controller) ->
    return {
      q: controller.get("searchWord")
      page: controller.get("currentPage")
      filter_tags: controller.get("filterTags")
    }

  deserializeParams: (params, controller) ->
    controller.set("currentPage", if params.page then Number(params.page) else 1)
    controller.set("searchWord", params.q)
    controller.set("facetTags.searchWord", params.q)
    if params.filter_tags
      params.filter_tags.forEach (t) ->
        controller.get("facetTags").addTagFilter(t)
    else
      controller.get("facetTags").get("filterTags").clear()


  loadModel: (controller) ->
    records = Seirenes.Pasokara.find(q: controller.get("searchWord"), filter_tags: controller.get("filterTags"), page: controller.get("currentPage"))
    controller.set("content", records)

  loadFacetTags: (facet_tags_controller) ->
    records = Seirenes.FacetTag.find(q: facet_tags_controller.get("searchWord"), filter_tags: facet_tags_controller.get("filterTags"))
    facet_tags_controller.set("content", records)

  setupController: (controller, model, params) ->
    facet_tags_controller = controller.get("facetTags")
    @loadModel(controller)
    @loadFacetTags(facet_tags_controller)

  renderTemplate: ->
    @render()
    @render('facetTags', {
      outlet: 'facetTags'
      controller: @get("controller.facetTags")
    })
    @render('searchField', {
      outlet: 'searchField'
      controller: @get("controller")
    })

  events:
    search: ->
      controller = @get("controller")
      @get("router").transitionAllParams(q: controller.get("searchWord"), page: 1)
