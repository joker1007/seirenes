<template>
  <h3 id="pasokara-preview-title">{{title}}</h3>
  <div id="pasokara-preview-player">
    <div id="pasokara-movie-area" v-component="preview_video_player" v-ref="preview_video_player"></div>
    <div id="pasokara-visualizer-area" v-show="recording">
      <div>
        <h4>Music</h4>
        <canvas id="music-level" class="level" width="640" height="256"></canvas>
        <canvas id="music-spectrum" class="spectrum" width="256" height="256"></canvas>
      </div>
      <div>
        <h4>Mic</h4>
        <canvas id="mic-level" class="level" width="640" height="256"></canvas>
        <canvas id="mic-spectrum" class="spectrum" width="256" height="256"></canvas>
      </div>
    </div>
  </div>
</template>

<script lang="coffee">
  Vue = require('vue')
  MusicLevelCanvasView = require('../views/level_canvas_view').MusicLevelCanvasView
  MicLevelCanvasView = require('../views/level_canvas_view').MicLevelCanvasView
  SpectrumCanvasView = require('../views/spectrum_canvas_view')
  module.exports = {
    created: ->
      @$on 'startRecording', (recorder) ->
        Vue.nextTick =>
          @musicLevelCanvasView = new MusicLevelCanvasView(canvasId: '#music-level', analyser: recorder.musicAnalyser)
          @musicLevelCanvasView.start()
          @micLevelCanvasView = new MicLevelCanvasView(canvasId: '#mic-level', analyser: recorder.micAnalyser)
          @micLevelCanvasView.start()
          @musicSpectrumCanvasView = new SpectrumCanvasView(canvasId: '#music-spectrum', analyser: recorder.musicAnalyser, imagePath: '/assets/spectrum-music.png')
          @musicSpectrumCanvasView.start()
          @micSpectrumCanvasView = new SpectrumCanvasView(canvasId: '#mic-spectrum', analyser: recorder.micAnalyser, imagePath: '/assets/spectrum-mic.png')
          @micSpectrumCanvasView.start()

      @$on 'stopRecording', ->
        @musicLevelCanvasView.stop()
        @micLevelCanvasView.stop()
        @musicSpectrumCanvasView.stop()
        @micSpectrumCanvasView.stop()

  }
</script>
