Seirenes.module "Views", (Views, App, Backbone, Marionette, $, _) ->
  Views.PlayingView = Marionette.ItemView.extend
    template: "backbone/templates/song_queue"

    initialize: ->
      @listenTo @model, "change", _.bind(@render, @)

    render: ->
      if @model.get("playing") == null
        @$el.html("")
      else
        Marionette.ItemView.prototype.render.apply(@, [])

    serializeData: ->
      @model.get("playing").toJSON()
