<template>
  <div id="video-layer" v-if="playing.movie_url">
    <video v-on="ended: ended" class="fullscreen" width="640" height="480" controls autoplay>
      <source type="video/mp4" v-attr="src: playing.movie_url"></source>
    </video>
  </div>
</template>
