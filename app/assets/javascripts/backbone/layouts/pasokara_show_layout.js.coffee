#= require ../app

Seirenes.module "Layouts", (Layout, App, Backbone, Marionette, $, _) ->
  Layout.PasokaraShowLayout = Marionette.LayoutView.extend
    template: "backbone/templates/pasokara_show_layout"
    regions:
      movieArea: "#pasokara-movie-area"
      recordingsArea: "#pasokara-recordings-area"

    initialize: ->
      @listenTo @model, "sync", _.bind(@render, @)
