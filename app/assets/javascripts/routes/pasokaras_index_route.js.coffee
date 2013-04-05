Seirenes.PasokarasIndexRoute = Ember.Route.extend
  loadModel: (controller) ->
    records = Seirenes.Pasokara.find(q: controller.get("searchWord"), filter_tags: controller.get("filterTags"), page: controller.get("currentPage"))
    controller.set("content", records)

  loadFacetTags: (facet_tags_controller) ->
    records = Seirenes.FacetTag.find(q: facet_tags_controller.get("searchWord"), filter_tags: facet_tags_controller.get("filterTags"))
    facet_tags_controller.set("content", records)

  setupController: (controller, model) ->
    facet_tags_controller = controller.get("facetTags")

    unless controller.get("observedByRoute")
      controller.set("observedByRoute", true)
      controller.addObserver 'currentPage', =>
        @loadModel(controller)
      controller.addObserver 'filterTags.@each', =>
        if controller.get("currentPage") == 1
          @loadModel(controller)
        else
          controller.set("currentPage", 1)

    unless facet_tags_controller.get("observedByRoute")
      facet_tags_controller.set("observedByRoute", true)
      facet_tags_controller.addObserver 'filterTags.@each', =>
        @loadFacetTags(facet_tags_controller)

    controller.set("searchWord", null)
    facet_tags_controller.set("searchWord", null)
    if controller.get("filterTags").length != 0
      facet_tags_controller.get('filterTags').clear()
    else if controller.get("currentPage") != 1
      controller.set("currentPage", 1)
      @loadFacetTags(facet_tags_controller)
    else
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
      if controller.get("currentPage") == 1
        @loadModel(controller)
      else
        controller.set("currentPage", 1)
      @loadFacetTags(@get("controller.facetTags"))
