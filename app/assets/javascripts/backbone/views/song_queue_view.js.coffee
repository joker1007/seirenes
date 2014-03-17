Seirenes.module "Views", (Views, App, Backbone, Marionette, $, _) ->
  Views.SongQueueView = Marionette.ItemView.extend
    template: "backbone/templates/song_queue"

  Views.SongQueueCollectionView = Marionette.CollectionView.extend
    itemView: Views.SongQueueView
