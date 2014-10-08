<template>
  <h3 id="pasokara-preview-title">{{title}}</h3>
  <div id="pasokara-preview-player">
    <div id="pasokara-movie-area" v-component="preview_video_player" v-ref="preview_video_player"></div>
  </div>
</template>
