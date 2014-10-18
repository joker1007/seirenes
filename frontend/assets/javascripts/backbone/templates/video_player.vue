<template>
  <div id="video-layer" v-if="playing.movie_url">
    <video v-on="ended: ended" class="fullscreen" width="640" height="480" controls autoplay>
      <source type="video/mp4" v-attr="src: playing.movie_url"></source>
    </video>
  </div>
</template>

<script lang="coffee">
  SongQueue = require('../models/song_queue').SongQueue
  module.exports =
    methods:
      ended: (e) ->
        new SongQueue(id: @playing.id, finish: true).save()
        setTimeout =>
          @$set('playing', {})
        , 2000
</script>
