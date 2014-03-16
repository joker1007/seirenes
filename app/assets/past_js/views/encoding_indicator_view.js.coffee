Seirenes.EncodingIndicatorView = Ember.View.extend
  tagName: 'div'
  classNames: ["js-indicator"]

  didInsertElement: ->
    @$().spin()
