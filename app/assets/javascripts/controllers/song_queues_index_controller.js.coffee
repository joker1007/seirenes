Seirenes.SongQueuesIndexController = Ember.ArrayController.extend({
  destroy: (song_queue) ->
    song_queue.deleteRecord()
    song_queue.on 'didDelete', ->
      jQuery.gritter.add
        image: '/assets/success.png'
        title: 'Success'
        text: "「#{song_queue.get("title")}」を予約から削除しました"
    song_queue.store.commit()
})

