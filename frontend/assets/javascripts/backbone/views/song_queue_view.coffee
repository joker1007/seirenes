Marionette = require('backbone.marionette')

SongQueueView = Marionette.ItemView.extend
  template: "backbone/templates/song_queue"

SongQueueCollectionView = Marionette.CollectionView.extend
  childView: SongQueueView

module.exports =
  SongQueueView: SongQueueView
  SongQueueCollectionView: SongQueueCollectionView
