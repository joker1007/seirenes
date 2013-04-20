Seirenes.FacetTagsController = Ember.ArrayController.extend
  searchWord: null
  filterTags: []

  addTagFilter: (tag) ->
    filterTags = @get("filterTags")
    unless filterTags.contains(tag)
      filterTags.pushObject(tag)

  removeTagFilter: (tag) ->
    @get("filterTags").removeObject(tag.toString())

  isEmptyFilterTags: (->
    @get("filterTags").lengtn == 0
  ).property("filterTags.@each")

Seirenes.facetTagsController = Seirenes.FacetTagsController.create()
