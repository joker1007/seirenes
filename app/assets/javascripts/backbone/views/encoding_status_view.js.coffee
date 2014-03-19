Seirenes.module "Views", (Views, App, Backbone, Marionette, $, _) ->
  Views.EncodingStatusView = Marionette.ItemView.extend
    template: "backbone/templates/encode_progress_bar"

    initialize: ->
      @listenTo @model, "change:progress", _.bind(@render, @)
