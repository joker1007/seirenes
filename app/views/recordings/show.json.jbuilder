json.recording do |json|
  json.partial! "recorded_song_entry", recorded_song: @recorded_song
end
