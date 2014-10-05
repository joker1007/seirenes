Backbone = require('backbone')
Backbone.$ = window.$
Marionette = require('backbone.marionette')
Router = require('director').Router

Seirenes = do (Backbone, Marionette) ->
  App = new Marionette.Application()

  stopControllers = ->
    console.log "stopControllers"

  player =  ->
    stopControllers()
    App.PlayerController.start()

  pasokaraShow = (id) ->
    stopControllers()
    App.PasokaraShowController.start()
    App.PasokaraShowController.API.show(_.parseInt(id))

  nop = ->
    console.log("nop")
    stopControllers()

  routes =
    '/player': player
    '/pasokaras/:id': pasokaraShow

  App.addInitializer ->
    router = Router(routes).configure
      notfound: nop
      html5history: true
    router.init()

    # hack for Turbolinks
    $(document).on "page:load", ->
      router.handler()

  App

module.exports = Seirenes
