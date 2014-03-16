json.extract! pasokara, :id, :title, :nico_vid, :nico_posted_at, :nico_view_count, :nico_mylist_count, :duration
json.url pasokara_url(pasokara, format: :json)
json.thumbnail_url pasokara.thumbnail.url
json.movie_url pasokara.movie_mp4.url
json.tag_ids pasokara.tag_ids
json.recording_ids pasokara.recorded_song_ids
json.favorited current_user ? pasokara.favorited_by?(current_user) : false
