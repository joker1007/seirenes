Seirenes.VideoPlayerView = Ember.View.extend
  tagName: "video"
  classNames: ["fullscreen"]
  attributeBindings: ["width", "height", "controls", "autoplay", "src"]
  width: 640
  height: 480
  controls: "controls"
  autoplay: "autoplay"
  srcBinding: "controller.playing.movieUrl"

  didInsertElement: ->
    @get("controller").send("stopLoop")
    $("video.fullscreen").on "ended", =>
      @playEnd()

  playEnd: ->
    controller = @get("controller")
    controller.send("pop")
    Ember.run.later(this, =>
      controller.send("startLoop")
    , 5000)
