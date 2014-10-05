#= require ../app

Seirenes.module "Models", (Models, App, Backbone, Marionette, $, _) ->
  Models.VocalCompressor = Backbone.Model.extend
    threshold: -15.0
    ratio: 2.0
    attack: 0.008

    initialize: ({source: @source}) ->
      throw new Error("no audio source") unless @source
      source = @source
      node = source.context.createDynamicsCompressor()
      node.threshold.value = @threshold
      node.ratio.value = @ragio
      node.attack.value = @attack
      source.connect(node)
      @output = node
