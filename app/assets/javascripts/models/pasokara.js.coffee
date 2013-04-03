Seirenes.Pasokara = DS.Model.extend
  title: DS.attr("string")
  nico_vid: DS.attr("string")
  nico_posted_at: DS.attr("date")
  nico_posted_at_formatted: DS.attr("string")
  nico_description: DS.attr("string")
  nico_view_count: DS.attr("number")
  nico_mylist_count: DS.attr("number")
  duration: DS.attr("number")
  url: DS.attr("string")
  thumbnailUrl: DS.attr("string")
  movieUrl: DS.attr("string")
  tags: DS.hasMany('Seirenes.Tag')

  nicoUrl: (->
    if @get("nico_vid")
      "http://www.nicovideo.jp/watch/#{@get("nico_vid")}"
  ).property("nico_vid")

  encode: ->
    $.ajax("/pasokaras/#{@id}/encoding", {
      type: "POST"
      dataType: "json"
      error: ->
        alert("エンコードジョブが開始できませんでした。")
    })
    @_get_encode_status()

  enqueue: ->
    $.ajax "/pasokaras/#{@id}/queues",
      type: "POST"
      dataType: "json"
      success: (data) ->
        jQuery.gritter.add
          image: '/assets/success.png'
          title: 'Success'
          text: "「#{data.pasokara.title}」を予約に追加しました"
      error: ->
        jQuery.gritter.add
          image: '/assets/error.png'
          title: 'Error'
          text: "予約を追加できません"

  _get_encode_status: (count = 0) ->
    if count < 200
      setTimeout(=>
        $.ajax("/pasokaras/#{@id}/encoding", {
          type: "GET"
          dataType: "json"
          success: (data) =>
            if data?.movie_url
              @reload()
            else
              @_get_encode_status(count + 1)
          error: (jqXHR) =>
            @_get_encode_status(count + 1)
        })
      , 5000)
    else
      alert("Encoding timeout")
