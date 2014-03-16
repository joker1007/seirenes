Seirenes.SongQueuesIndexRoute = Ember.Route.extend({
  model: ->
    Seirenes.SongQueue.find({})
})
