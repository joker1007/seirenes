Seirenes.PlayerController = Ember.ObjectController.extend({
  startLoop: ->
    @get("content").startLoop()

  stopLoop: ->
    @get("content").stopLoop()

  pop: ->
    @get("content").pop()
})

