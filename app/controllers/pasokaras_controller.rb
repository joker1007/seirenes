class PasokarasController < ApplicationController
  SearchParameter = Pasokara::Searchable::SearchParameter # class alias

  def index
    search = Pasokara.search_with_facet_tags(SearchParameter.new(tags: params[:filter_tags], page: params[:page]))
    @pasokaras = search.results
    @tags = @pasokaras.flat_map{|p| p.tags}.uniq
  end

  def show
    @pasokara = Pasokara.find(params[:id])
  end
end
