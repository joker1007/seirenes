#= require_tree ./config
#= require_tree ./templates

@Seirenes = do (Backbone, Marionette) ->
  App = new Marionette.Application()

  stopControllers = ->
    App.PlayerController.stop()
    App.PasokaraShowController.stop()

  Router = Backbone.Router.extend
    routes:
      "player": "player"
      "pasokaras/:id" : "pasokaraShow"
      "pasokaras.*" : "nop"
      "favorites.*" : "nop"
      "histories.*" : "nop"
      "song_queues.*" : "nop"
      "recordings.*" : "nop"
      ".*" : "nop"

    player: ->
      stopControllers()
      App.PlayerController.start()

    pasokaraShow: (id) ->
      stopControllers()
      App.PasokaraShowController.start()
      App.PasokaraShowController.API.show(_.parseInt(id))

    nop: ->
      console.log("nop")
      stopControllers()

  App.addInitializer ->
    new Router()
    Backbone.history.start(pushState: true)

    # hack for Turbolinks
    $(document).on "page:load", ->
      Backbone.history.stop()
      Backbone.history.start(pushState: true)

  App
