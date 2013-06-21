Seirenes.RecordingsIndexRoute = Ember.Route.extend
  model: ->
    Seirenes.Recording.find({})
