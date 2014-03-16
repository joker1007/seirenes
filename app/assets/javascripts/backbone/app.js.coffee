#= require_tree ./config
#= require_tree ./templates

@Seirenes = do (Backbone, Marionette) ->
  App = new Marionette.Application()

  Router = Backbone.Router.extend
    routes:
      "player": "player"

    player: ->
      App.PlayerController.start()

  App.addInitializer ->
    new Router()
    Backbone.history.start(pushState: true)

  App
