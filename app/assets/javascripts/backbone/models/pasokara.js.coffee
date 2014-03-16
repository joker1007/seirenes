#= require ../app

Seirenes.module "Models", (Models, App, Backbone, Marionette, $, _) ->
  Models.Pasokara = Backbone.Model.extend
    urlRoot: "/pasokaras"
