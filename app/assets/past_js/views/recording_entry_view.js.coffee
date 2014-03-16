Seirenes.RecordingEntryView = Ember.View.extend
  templateName: "recordings/entry"

  removeEntry: (recording) ->
    if confirm("#{recording.get("title")}を予約から削除しますか？")
      @get("controller").send("destroy", recording)
      @destroy()
