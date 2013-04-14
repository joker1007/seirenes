class PasokarasController < ApplicationController
  SearchParameter = Pasokara::Searchable::SearchParameter # class alias

  def index
    if request.xhr?
      order_by = params[:order_by] ? params[:order_by].split(" ").map(&:to_sym) : [:created_at, :desc]
      search = Pasokara.search_with_facet_tags(SearchParameter.new(keyword: params[:q].presence, tags: params[:filter_tags], page: params[:page], order_by: [order_by]))
      @pasokaras = search.results
      @tags = @pasokaras.flat_map{|p| p.tags}.uniq
    end
  end

  def show
    @pasokara = Pasokara.find(params[:id])
  end
end
