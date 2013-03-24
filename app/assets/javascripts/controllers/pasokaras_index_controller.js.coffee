Seirenes.PasokarasIndexController = Ember.ArrayController.extend
  addTagFilter: (tag) ->
    filterTags = @get("filterTags")
    filterTags.pushObject(tag)
    filterTags.uniq()
    @reload()

  reload: ->
    @set("content", Seirenes.Pasokara.find(filter_tags: @get("filterTags")))
