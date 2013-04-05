Seirenes.SongQueuesIndexRoute = Ember.Route.extend({
  setupController: (controller, model)->
    controller.set("content", Seirenes.SongQueue.find())
})
