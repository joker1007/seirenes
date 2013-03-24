Seirenes.FacetTagsController = Ember.ArrayController.extend
  addTagFilter: (tag) ->
    filterTags = @get("filterTags")
    filterTags.pushObject(tag)
    filterTags.uniq()
    @reload()

  reload: ->
    @set("content", Seirenes.FacetTag.find(filter_tags: @get("filterTags")))
