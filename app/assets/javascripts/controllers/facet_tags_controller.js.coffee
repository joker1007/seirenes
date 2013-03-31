Seirenes.FacetTagsController = Ember.ArrayController.extend
  filterTags: []

  addTagFilter: (tag) ->
    filterTags = @get("filterTags")
    unless filterTags.contains(tag)
      filterTags.pushObject(tag)

  reload: ->
    @set("content", Seirenes.FacetTag.find(filter_tags: @get("filterTags")))
