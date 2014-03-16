Seirenes.RecordingsIndexController = Ember.ArrayController.extend
  destroy: (recording) ->
    recording.deleteRecord()
    recording.on 'didDelete', ->
      jQuery.gritter.add
        image: "#{gritter_success_image_path}"
        title: 'Success'
        text: "「#{recording.get("title")}」の録音を削除しました"
    recording.store.commit()
