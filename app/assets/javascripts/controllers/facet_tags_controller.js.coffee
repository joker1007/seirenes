Seirenes.FacetTagsController = Ember.ArrayController.extend
  searchWord: null
  filterTags: []

  addTagFilter: (tag) ->
    filterTags = @get("filterTags")
    unless filterTags.contains(tag)
      filterTags.pushObject(tag)
