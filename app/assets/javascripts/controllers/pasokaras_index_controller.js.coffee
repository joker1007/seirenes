#= require emberjs-pageable

Seirenes.PasokarasIndexController = Ember.ArrayController.extend VG.Mixins.Pageable,
  addTagFilter: (tag) ->
    filterTags = @get("filterTags")
    filterTags.pushObject(tag)
    filterTags.uniq()
    @reload()

  reload: ->
    @set("content", Seirenes.Pasokara.find(filter_tags: @get("filterTags")))
