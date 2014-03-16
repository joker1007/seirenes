Seirenes.HistoriesIndexRoute = Ember.Route.extend({
  model: ->
    Seirenes.History.find({})
})
