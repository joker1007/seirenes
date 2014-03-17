#= require ../app

Seirenes.module "Models", (Models, App, Backbone, Marionette, $, _) ->
  Models.EncodingStatus = Backbone.Model.extend
    url: -> "/pasokaras/#{@id}/encoding"

    initialize: ({id: @id}) ->

    encode: ->
      $.ajax @url(),
        type: "POST"
        dataType: "json"
        success: =>
          @periodicallyCheck()
        error: ->
          alert("エンコードジョブが開始できませんでした。")

    periodicallyCheck: (count = 0) ->
      if count < 200
        setTimeout =>
          @fetch().done(=>
            console.log @get("movie_url")
            @trigger("encoded", @get("movie_url"))
          ).fail(=>
            console.log "retry"
            @periodicallyCheck(count + 1)
          )
        , 5000
      else
        alert("Encoding timeout")
