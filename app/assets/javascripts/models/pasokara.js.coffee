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
    })
    @_get_encode_status()

  _get_encode_status: (count = 0) ->
    if count < 600
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
