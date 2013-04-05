Seirenes.PlayerRoute = Ember.Route.extend({
  model: ->
    Seirenes.player

  activate: ->
    Seirenes.player.startLoop()

  deactivate: ->
    Seirenes.player.stopLoop()
})
