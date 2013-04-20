Seirenes.FacetTagView = Ember.View.extend
  tagName: "span"
  classNames: ["facet-tag"]
  template: Ember.Handlebars.compile("{{name}}({{count}})")

  click: ->
    @get("controller").send("addTagFilter", @get("context.name"))
