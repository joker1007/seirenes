json.pasokara do |json|
  json.extract! @pasokara, :title, :nico_vid, :nico_posted_at, :nico_view_count, :nico_mylist_count, :duration
  json.thumbnail_url @pasokara.thumbnail.url
end
