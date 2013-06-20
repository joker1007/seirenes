json.recordings do |json|
  json.array!(@recorded_songs) do |recorded_song|
    json.partial! "recorded_song_entry", recorded_song: recorded_song
  end
end
