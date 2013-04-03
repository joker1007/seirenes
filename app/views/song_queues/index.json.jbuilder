json.song_queues do |json|
  json.array!(@song_queues) do |song_queue|
    json.extract! song_queue, :id, :title, :pasokara_id, :user_id
    json.url song_queue_url(song_queue, format: :json)
    json.pasokara_url pasokara_url(song_queue.pasokara, format: :json)
    json.thumbnail_url song_queue.thumbnail.url
  end
end
