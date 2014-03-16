Ember.Handlebars.registerBoundHelper('formatDuration', (value, option) ->
  min = Math.floor(value / 60).toString()
  tmp = (value % 60)
  sec = if tmp < 10 then "0#{tmp.toString()}" else tmp.toString()
  "#{min}:#{sec}"
)
