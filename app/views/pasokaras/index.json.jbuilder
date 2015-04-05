json.set! controller.controller_name do |json|
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
