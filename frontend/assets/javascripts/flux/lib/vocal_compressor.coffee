class VocalCompressor
  threshold: -15.0
  ratio: 2.0
  attack: 0.008

  constructor: ({source: @source}) ->
    throw new Error("no audio source") unless @source
    source = @source
    node = source.context.createDynamicsCompressor()
    node.threshold.value = @threshold
    node.ratio.value = @ratio
    node.attack.value = @attack
    source.connect(node)
    @output = node

module.exports = VocalCompressor
