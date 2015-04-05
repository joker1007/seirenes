json.extract! pasokara, :id, :title, :nico_vid, :nico_posted_at, :nico_view_count, :nico_mylist_count, :duration
json.url pasokara_url(pasokara)
json.thumbnail_url pasokara.thumbnail.url
json.movie_url pasokara.movie_mp4.url
json.tags pasokara.tags.map(&:name)
json.tag_ids pasokara.tag_ids
json.favorited current_user ? pasokara.favorited_by?(current_user) : false
