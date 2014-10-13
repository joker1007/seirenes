<template>
  <div id="pasokara-preview">
    <video id="preview-player" class="preview" v-if="movie_url" controls>
      <source type="video/mp4" v-attr="src: movie_url"></source>
    </video>
    <div class="progress" v-if="encoding">
      <div class="progress-bar" role="progressbar" aria-valuenow="{{encodingProgress}}" aria-valuemin="0" aria-valuemax="100" style="width: {{encodingProgress}}%;">
        {{encodingProgress}}%
      </div>
    </div>
  </div>
  <div id="record-control">
    <button class="js-start_rec" v-on="click: startRecording">Start Rec</button>
    <button class="js-stop_rec" v-on="click: stopRecording">Stop Rec</button>
    <div id="recorded" v-if="recordedUrl">
      <audio v-attr="src: recordedUrl" controls></audio>
    </div>
  </div>
</template>

<script lang="coffee">
  Recorder = require('../models/recorder')
  module.exports =
    methods:
      startRecording: ->
        @recorder = new Recorder
          video: document.getElementById('preview-player')
          started: =>
            @recording = true
            @$dispatch('startRecording', @recorder)
      stopRecording: ->
        @recorder.stopRecord (blob) =>
          console.log blob
          @recording = false
          @recordedData = blob
          @recordedUrl = URL.createObjectURL(blob)
          @$dispatch('stopRecording', @recorder)
</script>
