#= require emberjs-pageable

Seirenes.PasokarasIndexController = Ember.ArrayController.extend VG.Mixins.Pageable,
  currentPage: null
  facetTags: Seirenes.FacetTagsController.create()
  filterTagsBinding: "facetTags.filterTags"

  totalPagesBinding: "content.meta.total_pages"
  perPageBinding: "content.meta.per_page"

