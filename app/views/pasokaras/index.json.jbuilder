json.set! "pasokaras" do |json|
  json.partial! "pasokaras/entry", collection: @pasokaras, as: :pasokara
end
json.meta do |json|
  json.total_pages @search.total_pages
  json.per_page Pasokara::DEFAULT_PER_PAGE
  json.current_page @search.current_page
  json.total_entries @search.total_count
end
json.facets(@facets) do |f|
  json.count f["count"]
  json.name f["term"]
end
