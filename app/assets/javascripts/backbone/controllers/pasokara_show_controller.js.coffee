#= require ../app

Seirenes.module "PasokaraShowController", (PasokaraShowController, App, Backbone, Marionette, $, _) ->
  @startWithParent = false

  APIBase = Marionette.Controller.extend
    show: (id) ->
      @pasokara = new App.Models.Pasokara(id: id)
      @layout = new App.Layouts.PasokaraShowLayout(model: @pasokara)
      $(".contents").append(@layout.el)
      @pasokara.fetch()
      encodingStatus = new App.Models.EncodingStatus(id: @pasokara.id)
      @pasokara.encodingStatus = encodingStatus
      @listenTo encodingStatus, "encoded", (url) ->
        @pasokara.set(movie_url: url)
      encodingStatus.encode()

      @listenTo @layout, "render", =>
        @playerView = new App.Views.PreviewVideoPlayer(model: @pasokara)
        @layout.movieArea.show(@playerView)

  @addInitializer ->
    controller = new APIBase()
    @API = controller

  @addFinalizer ->
    @API.layout.destroy()
    @API.destroy()
