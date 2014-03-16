#= require emberjs-pageable
#= require ./facet_tags_controller

Seirenes.PasokarasIndexController = Ember.ArrayController.extend VG.Mixins.Pageable,
  facetTags: Seirenes.facetTagsController
  filterTagsBinding: "facetTags.filterTags"
  searchWordBinding: "facetTags.searchWord"

  totalPagesBinding: "content.meta.total_pages"
  perPageBinding: "content.meta.per_page"

  sortOrderBy: "title_sort asc"

  observeParams: ["currentPage"]

  changeFilterTags: (->
    # 他に方法無いものか
    if @get("target.router").currentHandlerInfos
      if @get("target").location.location.pathname == "/pasokaras"
        @transitionAllParams({page: 1, filter_tags: @get("filterTags"), q: @get("searchWord"), order_by: @get("sortOrderBy")})
      else
        @transitionToRouteWithParams("pasokaras.index", {page: 1, filter_tags: @get("filterTags"), q: @get("searchWord"), order_by: @get("sortOrderBy")})
  ).observes("filterTags.@each")

  enqueue: (pasokara) ->
    if confirm("#{pasokara.get("title")}を予約しますか？")
      pasokara.enqueue()

  addFavorite: (pasokara) ->
    if confirm("#{pasokara.get("title")}をお気に入りに追加しますか？")
      pasokara.addFavorite()

  removeFavorite: (pasokara) ->
    if confirm("#{pasokara.get("title")}をお気に入りから除しますか？")
      pasokara.on "unfavorited", =>
        # ここも何か間違ってる
        if @get("target").location.location.pathname == "/favorites"
          @get("content").removeObject(pasokara)
      pasokara.removeFavorite()

