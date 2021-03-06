class DelayEffector
  delayTime: 0.2
  feedbackLevel: 0.15
  wetGainLevel: 0.12
  dryGainLevel: 0.9

  constructor: ({source: @source}) ->
    throw new Error("no audio source") unless @source
    source = @source
    @input    = source.context.createGain()
    @output   = source.context.createGain()
    @dryGain  = source.context.createGain()
    @wetGain  = source.context.createGain()
    @feedback = source.context.createGain()
    @delay    = source.context.createDelay()

    @dryGain.gain.value    = @dryGainLevel
    @wetGain.gain.value    = @wetGainLevel
    @feedback.gain.value   = @feedbackLevel
    @delay.delayTime.value = @delayTime

    source.connect(@input)
    @input.connect(@delay)
    @input.connect(@dryGain)
    @delay.connect(@wetGain)
    @delay.connect(@feedback)
    @feedback.connect(@delay)

    @dryGain.connect(@output)
    @wetGain.connect(@output)

module.exports = DelayEffector
