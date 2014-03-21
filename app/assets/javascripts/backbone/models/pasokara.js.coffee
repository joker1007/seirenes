#= require ../app

Seirenes.module "Models", (Models, App, Backbone, Marionette, $, _) ->
  Models.Pasokara = Backbone.Model.extend
    urlRoot: "/pasokaras"

    uploadRecordedData: ->
      $dummyForm = $(document.createElement("form"))
      $dummyForm.fileupload
        dataType: 'json'
        url: "/pasokaras/#{@id}/recordings"
        maxChunkSize: 1048576
        done: (e, data) ->
          jQuery.gritter.add
            image: "#{gritter_success_image_path}"
            title: 'Success'
            text: "アップロードが成功しました"
        fail: (e, data) ->
          jQuery.gritter.add
            image: "#{gritter_error_image_path}"
            title: 'Error'
            text: "アップロードに失敗しました。#{data}"
      $dummyForm.fileupload('send', {files: @get("recordedData")})
