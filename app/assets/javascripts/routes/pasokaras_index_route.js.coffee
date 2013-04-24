Seirenes.PasokarasIndexRoute = Ember.Route.extend
  serializeParams: (controller) ->
    return {
      q: controller.get("searchWord")
      page: controller.get("currentPage")
      filter_tags: controller.get("filterTags")
      order_by: controller.get("sortOrderBy")
    }

  deserializeParams: (params, controller) ->
    controller.set("currentPage", if params.page then Number(params.page) else 1)
    controller.set("searchWord", params.q)
    controller.set("sortOrderBy", params.order_by)
    controller.set("facetTags.searchWord", params.q)
    if params.filter_tags
      params.filter_tags.forEach (t) ->
        controller.get("facetTags").addTagFilter(t)
    else
      controller.get("facetTags").get("filterTags").clear()


  loadModel: (controller) ->
    records = Seirenes.Pasokara.find(q: controller.get("searchWord"), filter_tags: controller.get("filterTags"), page: controller.get("currentPage"), order_by: controller.get("sortOrderBy"))
    controller.set("content", records)

  loadFacetTags: (facet_tags_controller) ->
    facet_tags_controller.loadModel()

  setupController: (controller, model, params) ->
    facet_tags_controller = controller.get("facetTags")
    @loadModel(controller)
    @loadFacetTags(facet_tags_controller)

  renderTemplate: ->
    @render()
    @render('searchField', {
      outlet: 'searchField'
      controller: @get("controller")
    })

  events:
    search: ->
      controller = @get("controller")
      @get("router").transitionAllParams(q: controller.get("searchWord"), page: 1, order_by: controller.get("sortOrderBy"))

    sort: ->
      controller = @get("controller")
      @get("router").transitionAllParams(q: controller.get("searchWord"), page: 1, filter_tags: controller.get("filterTags"), order_by: controller.get("sortOrderBy"))
