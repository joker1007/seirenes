<template>
  <div>
    <div class="song_queue" v-repeat="items" v-component="song_queue_item">
      <img class="thumb" v-attr="src: thumbnail_url" width="160" height="120">
      <span class="title">
        {{title}}
      </span>
    </div>
  <div>
</template>

<script>
  module.exports = {
    data: {
      items: []
    }
  }
</script>
