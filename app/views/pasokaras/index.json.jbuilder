json.set! controller.controller_name do |json|
  json.array!(@pasokaras) do |pasokara|
    json.partial! "pasokaras/entry", pasokara: pasokara
  end
end
json.tags do |json|
  json.array!(@tags) do |tag|
    json.extract! tag, :id, :name
  end
end
json.meta do |json|
  json.total_pages @pasokaras.total_pages
  json.per_page Pasokara::DEFAULT_PER_PAGE
  json.current_page @pasokaras.current_page
  json.total_entries @pasokaras.total_count
end
