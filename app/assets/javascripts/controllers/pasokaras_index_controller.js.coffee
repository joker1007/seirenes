#= require emberjs-pageable

Seirenes.PasokarasIndexController = Ember.ArrayController.extend VG.Mixins.Pageable,
  facetTags: Seirenes.FacetTagsController.create()
  filterTagsBinding: "facetTags.filterTags"
  searchWordBinding: "facetTags.searchWord"

  totalPagesBinding: "content.meta.total_pages"
  perPageBinding: "content.meta.per_page"

  sortOrderBy: "title_sort asc"

  observeParams: ["currentPage"]

  changeFilterTags: (->
    if @get("target.router").currentHandlerInfos
      @transitionAllParams({page: 1, filter_tags: @get("filterTags"), q: @get("searchWord"), order_by: @get("sortOrderBy")})
  ).observes("filterTags.@each")

  enqueue: (pasokara) ->
    if confirm("#{pasokara.get("title")}を予約しますか？")
      pasokara.enqueue()
