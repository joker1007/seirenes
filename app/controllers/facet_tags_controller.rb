class FacetTagsController < ApplicationController
  SearchParameter = Pasokara::Searchable::SearchParameter # class alias

  def index
    search = Pasokara.search_with_facet_tags(SearchParameter.new(keyword: params[:q].presence, tags: params[:filter_tags]))
    @facet_tags = search.facet(:tags).rows.take(50)
  end
end
