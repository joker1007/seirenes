Marionette = require('backbone.marionette')

PlayerLayout = Marionette.LayoutView.extend
  regions:
    playing: "#playing"
    songQueueList: "#song_queue-list"
    videoArea: "#video-area"

module.exports = PlayerLayout
