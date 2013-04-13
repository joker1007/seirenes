#= require emberjs-pageable

Seirenes.PasokarasIndexController = Ember.ArrayController.extend VG.Mixins.Pageable,
  facetTags: Seirenes.FacetTagsController.create()
  filterTagsBinding: "facetTags.filterTags"
  searchWordBinding: "facetTags.searchWord"

  totalPagesBinding: "content.meta.total_pages"
  perPageBinding: "content.meta.per_page"

  observeParams: ["currentPage"]

  changeFilterTags: (->
    if @get("target.router").currentHandlerInfos
      @transitionToRouteWithParams("pasokaras.index", {page: 1, filter_tags: @get("filterTags"), q: @get("searchWord")})
  ).observes("filterTags.@each")

  enqueue: (pasokara) ->
    if confirm("#{pasokara.get("title")}を予約しますか？")
      pasokara.enqueue()
