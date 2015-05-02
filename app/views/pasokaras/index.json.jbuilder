json.set! "pasokaras" do |json|
  json.array!(@pasokaras) do |pasokara|
    json.partial! "pasokaras/entry", pasokara: pasokara
  end
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
