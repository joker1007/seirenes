#= require ../app

Seirenes.module "Layouts", (Layout, App, Backbone, Marionette, $, _) ->
  Layout.PlayerLayout = Marionette.Layout.extend
    regions:
      playing: "#playing"
      songQueueList: "#song_queue-list"
      videoArea: "#video-area"

