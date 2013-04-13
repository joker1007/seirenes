class PasokarasController < ApplicationController
  SearchParameter = Pasokara::Searchable::SearchParameter # class alias

  def index
    if request.xhr?
      search = Pasokara.search_with_facet_tags(SearchParameter.new(keyword: params[:q].presence, tags: params[:filter_tags], page: params[:page]))
      @pasokaras = search.results
      @tags = @pasokaras.flat_map{|p| p.tags}.uniq
    end
  end

  def show
    @pasokara = Pasokara.find(params[:id])
  end
end
