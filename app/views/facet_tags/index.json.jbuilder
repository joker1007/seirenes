json.facet_tags do |json|
  json.array!(@facet_tags) do |facet|
    json.name facet.value
    json.count facet.count
  end
end
