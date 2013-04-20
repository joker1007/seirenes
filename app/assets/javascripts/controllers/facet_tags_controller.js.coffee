Seirenes.FacetTagsController = Ember.ArrayController.extend
  searchWord: null
  filterTags: []

  addTagFilter: (tag) ->
    filterTags = @get("filterTags")
    unless filterTags.contains(tag)
      filterTags.pushObject(tag)

  currentFilterTags: (->
    @get("filterTags").join(" > ")
  ).property("filterTags.@each")

  isEmptyFilterTags: (->
    @get("filterTags").lengtn == 0
  ).property("filterTags.@each")
