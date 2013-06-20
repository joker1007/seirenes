Seirenes.RecordingsIndexRoute = Ember.Route.extend
  setupController: (controller, model, params) ->
    controller.set("content", Seirenes.Recording.find({}))
