json.pasokaras do |json|
  json.array!(@pasokaras) do |pasokara|
    json.extract! pasokara, :id, :title, :nico_vid, :nico_posted_at, :nico_view_count, :nico_mylist_count, :duration
    json.nico_posted_at_formatted l(pasokara.nico_posted_at)
    json.url pasokara_url(pasokara, format: :json)
    json.thumbnail_url pasokara.thumbnail.url
    json.tag_ids pasokara.tag_ids
  end
end
json.tags do |json|
  json.array!(@tags) do |tag|
    json.extract! tag, :id, :name
  end
end
