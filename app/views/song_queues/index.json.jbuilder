json.set! controller.controller_name do |json|
  json.array!(@song_queues) do |song_queue|
    json.extract! song_queue, :id, :title, :pasokara_id, :user_id
    json.url song_queue_url(song_queue, format: :json)
    json.pasokara_url pasokara_url(song_queue.pasokara, format: :json)
    json.thumbnail_url song_queue.thumbnail.url
    json.movie_url song_queue.movie_mp4.url
  end
end
