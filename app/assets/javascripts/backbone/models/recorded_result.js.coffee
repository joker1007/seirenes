#= require ../app

Seirenes.module "Models", (Models, App, Backbone, Marionette, $, _) ->
  Models.RecordedResult = Backbone.Model.extend()
