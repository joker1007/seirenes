Seirenes.FavoritesIndexRoute = Ember.Route.extend
  serializeParams: (controller) ->
    return {
      page: @controllerFor("pasokaras.index").get("currentPage")
      order_by: @controllerFor("pasokaras.index").get("sortOrderBy")
    }

  deserializeParams: (params, controller) ->
    @controllerFor("pasokaras.index").set("currentPage", if params.page then Number(params.page) else 1)
    @controllerFor("pasokaras.index").set("sortOrderBy", params.order_by)

  setupController: (controller, model, params) ->
    facet_tags_controller = controller.get("facetTags")
    @loadModel(@controllerFor("pasokaras.index"))

  loadModel: (controller) ->
    records = Seirenes.Favorite.find(page: controller.get("currentPage"), order_by: controller.get("sortOrderBy"))
    controller.set("content", records)

  renderTemplate: ->
    @render('pasokaras.index', {
      outlet: 'pasokaras'
      controller: @controllerFor("pasokaras.index")
    })
    @render('searchField', {
      outlet: 'searchField'
      controller: @controllerFor("pasokaras.index")
    })

  events:
    search: ->
      controller = @controllerFor("pasokaras.index")
      @get("router").transitionToRouteWithParams('pasokaras.index', {q: controller.get("searchWord"), page: 1, order_by: controller.get("sortOrderBy")})

