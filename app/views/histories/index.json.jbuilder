json.set! controller.controller_name do |json|
  json.array!(@histories) do |history|
    json.extract! history, :id, :title, :pasokara_id, :user_id
    json.pasokara_url pasokara_url(history.pasokara, format: :json)
    json.thumbnail_url history.thumbnail.url
    json.movie_url history.movie_mp4.url
  end
end
