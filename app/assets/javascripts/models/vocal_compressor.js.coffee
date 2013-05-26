Seirenes.VocalCompressor = Ember.Object.extend
  threshold: -15.0
  ratio: 2.0
  attack: 0.008

  init: ->
    throw new Error("no audio source") unless @get("source")
    source = @get("source")
    node = source.context.createDynamicsCompressor()
    node.threshold.value = @get("threshold")
    node.ratio.value = @get("ragio")
    node.attack.value = @get("attack")
    source.connect(node)
    @set("output", node)
