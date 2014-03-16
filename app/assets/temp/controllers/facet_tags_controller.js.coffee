Seirenes.FacetTagsController = Ember.ArrayController.extend
  searchWord: null
  tagSearchWord: null
  filterTags: []

  addTagFilter: (tag) ->
    filterTags = @get("filterTags")
    unless filterTags.contains(tag)
      filterTags.pushObject(tag)

  removeTagFilter: (tag) ->
    @get("filterTags").removeObject(tag.toString())

  isEmptyFilterTags: (->
    @get("filterTags").length == 0
  ).property("filterTags.@each")

  clearTagSearchWord: ->
    @set("tagSearchWord", "")

  tagSearchWordChanged: (->
    Ember.run.backburner.debounce this, @updateCurrentRecord, 500
  ).observes("tagSearchWord")

  updateCurrentRecord: ->
    if @get("currentRecord")
      if @get("currentRecord").isLoaded
        @set("currentRecord", @loadModel())
      else
        @tagSearchWordChanged()
    else
      @set("currentRecord", @loadModel())

  loadModel: ->
    records = Seirenes.FacetTag.find(q: @get("searchWord"), filter_tags: @get("filterTags"), tagq: @get("tagSearchWord"))
    @set("content", records)
    records

Seirenes.facetTagsController = Seirenes.FacetTagsController.create()
