#= require ../app

Seirenes.module "Models", (Models, App, Backbone, Marionette, $, _) ->
  Models.Player = Backbone.Model.extend
    initialize: ({songQueues: @songQueues}) ->
      @set(playing: null)
      @listenTo @songQueues, "sync", _.bind(@pickup, @)

    pickup: ->
      if @get("playing") == null && !@songQueues.isEmpty()
        @set(playing: @songQueues.at(0))
        @encode()

    encode: ->
      playing = @get("playing")
      $.ajax "/pasokaras/#{playing.get("pasokara_id")}/encoding",
        type: "POST"
        dataType: "json"
        success: =>
          @_checkEncodeStatus()
        error: ->
          alert("エンコードジョブが開始できませんでした。")

    _checkEncodeStatus: (count = 0) ->
      playing = @get("playing")
      if count < 200
        setTimeout =>
          $.ajax("/pasokaras/#{playing.get("pasokara_id")}/encoding", {
            type: "GET"
            dataType: "json"
            success: (data) =>
              if data?.movie_url
                @get("playing").set(movie_url: data.movie_url)
              else
                @_checkEncodeStatus(count + 1)
            error: (jqXHR) =>
              @_checkEncodeStatus(count + 1)
          })
        , 5000
      else
        alert("Encoding timeout")
