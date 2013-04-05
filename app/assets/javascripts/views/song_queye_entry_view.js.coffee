Seirenes.SongQueueEntryView = Ember.View.extend
  templateName: "song_queues/entry"

  removeEntry: (song_queue) ->
    if confirm("#{song_queue.get("title")}を予約から削除しますか？")
      @get("controller").send("destroy", song_queue)
      @destroy()
