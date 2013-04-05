#= require emberjs-pageable

Seirenes.PasokarasIndexController = Ember.ArrayController.extend VG.Mixins.Pageable,
  facetTags: Seirenes.FacetTagsController.create()
  filterTagsBinding: "facetTags.filterTags"
  searchWordBinding: "facetTags.searchWord"

  totalPagesBinding: "content.meta.total_pages"
  perPageBinding: "content.meta.per_page"

  enqueue: (pasokara) ->
    if confirm("#{pasokara.get("title")}を予約しますか？")
      pasokara.enqueue()
