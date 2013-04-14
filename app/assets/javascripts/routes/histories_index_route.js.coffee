Seirenes.HistoriesIndexRoute = Ember.Route.extend({
  setupController: (controller, model)->
    controller.set("content", Seirenes.History.find({}))
})
