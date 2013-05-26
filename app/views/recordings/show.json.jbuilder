json.recording do |json|
  json.extract! @recorded_song, :id, :public_flag, :user_id, :pasokara_id
  json.data_url @recorded_song.data.url
end
