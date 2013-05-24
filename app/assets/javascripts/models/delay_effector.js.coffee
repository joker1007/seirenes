Seirenes.DelayEffector = Ember.Object.extend
  delayTime: 0.15
  feedbackLevel: 0.2
  wetGainLevel: 0.2
  dryGainLevel: 1

  init: ->
    throw new Error("no audio source") unless @get("source")
    source = @get("source")
    @set("input", source.context.createGain())
    @set("output", source.context.createGain())
    @set("dryGain", source.context.createGain())
    @set("wetGain", source.context.createGain())
    @set("feedback", source.context.createGain())
    @set("delay", source.context.createDelay())

    @get("dryGain").gain.value = @get("dryGainLevel")
    @get("wetGain").gain.value = @get("wetGainLevel")
    @get("feedback").gain.value = @get("feedbackLevel")
    @get("delay").delayTime.value = @get("delayTime")

    source.connect(@get("input"))
    @get("input").connect(@get("delay"))
    @get("input").connect(@get("dryGain"))
    @get("delay").connect(@get("wetGain"))
    @get("delay").connect(@get("feedback"))
    @get("feedback").connect(@get("delay"))

    @get("dryGain").connect(@get("output"))
    @get("wetGain").connect(@get("output"))
