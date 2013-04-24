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
    if @get("currentRecord")
      if @get("currentRecord").isLoaded
        @set("currentRecord", @loadModel())
      else
        @get("currentRecord").on "didLoad", =>
          @set("currentRecord", @loadModel())
    else
      @set("currentRecord", @loadModel())
  ).observes("tagSearchWord")

  loadModel: ->
    records = Seirenes.FacetTag.find(q: @get("searchWord"), filter_tags: @get("filterTags"), tagq: @get("tagSearchWord"))
    @set("content", records)
    records

Seirenes.facetTagsController = Seirenes.FacetTagsController.create()
