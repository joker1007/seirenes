Seirenes.InfoTagView = Ember.View.extend
  tagName: "span"
  classNames: ["info-tag"]
  template: Ember.Handlebars.compile("{{view.content.name}}")

  click: ->
    console.log @get("content.name")
    @get("controller").send("addTagFilter", @get("content.name"))
