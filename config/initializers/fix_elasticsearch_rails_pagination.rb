module Elasticsearch::Model::Response::Pagination::Kaminari
  def limit_value
    search.definition[:size] || 0
  end

  def offset_value
    search.definition[:from] || 0
  end
end
