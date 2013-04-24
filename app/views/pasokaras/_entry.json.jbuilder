json.extract! pasokara, :id, :title, :nico_vid, :nico_posted_at, :nico_view_count, :nico_mylist_count, :duration
json.nico_posted_at_formatted pasokara.nico_posted_at ? l(pasokara.nico_posted_at) : nil
json.url pasokara_url(pasokara, format: :json)
json.thumbnail_url pasokara.thumbnail.url
json.movie_url pasokara.movie_mp4.url
json.tag_ids pasokara.tag_ids
json.favorited current_user ? pasokara.favorited_by?(current_user) : false