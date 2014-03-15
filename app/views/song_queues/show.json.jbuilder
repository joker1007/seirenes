json.extract! @song_queue, :id, :pasokara_id, :user_id, :created_at
json.pasokara do
  json.extract! @song_queue.pasokara, :id, :title, :thumbnail
end
