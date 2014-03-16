#= require_tree ./config
#= require_tree ./templates

@Seirenes = do (Backbone, Marionette) ->
  App = new Marionette.Application()

  clearControllers = ->
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
      ".*" : "nop"

    player: ->
      console.log("player")
      clearControllers()
      App.PlayerController.start()

    pasokaraShow: (id) ->
      console.log("pasokaraShow")
      clearControllers()
      App.PasokaraShowController.start()
      App.PasokaraShowController.API.show(_.parseInt(id))

    nop: ->
      console.log("nop")
      clearControllers()

  App.addInitializer ->
    new Router()
    Backbone.history.start(pushState: true)
    $(document).on "page:load", ->
      console.log "page:load"
      Backbone.history.stop()
      Backbone.history.start(pushState: true)

  App
