<template>
  <div id="pasokara-preview">
    <video id="preview-player" v-if="movie_url" controls>
      <source type="video/mp4" v-attr="src: movie_url"></source>
    </video>
    <div class="progress" v-if="encoding">
      <div class="progress-bar" role="progressbar" aria-valuenow="{{encodingProgress}}" aria-valuemin="0" aria-valuemax="100" style="width: {{encodingProgress}}%;">
        {{encodingProgress}}%
      </div>
    </div>
  </div>
  <div id="record-control">
    <button class="js-add_rec">Add Record Track</button>
    <button class="js-start_rec">Start Rec</button>
    <button class="js-stop_rec">Stop Rec</button>
    <div id="recorded"></div>
  </div>
</template>
