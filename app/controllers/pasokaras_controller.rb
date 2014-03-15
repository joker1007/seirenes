class PasokarasController < ApplicationController
  before_action :set_pasokara, only: [:show, :update, :unfavorite]

  SearchParameter = Pasokara::Searchable::SearchParameter # class alias

  def index
    order_by = params[:order_by].try(:split, " ").try(:map, &:to_sym) || [:created_at, :desc]
    keyword = params[:q]
    @search = Pasokara.search_with_facet_tags(SearchParameter.new(keyword: keyword, tags: params[:filter_tags], page: params[:page], order_by: [order_by], user_id: params[:user_id]))
    @pasokaras = @search.records.includes(:tags)
    @facets = @search.response["facets"]["tags"]["terms"]
    @tags = @pasokaras.flat_map{|p| p.tags}.uniq
  end

  def show
    respond_to do |format|
      format.html { render "index" }
      format.json
    end
  end

  # dummy for ember-data
  def update
    render "show"
  end

  def unfavorite
    @pasokara.favorites.where(user_id: current_user.id).destroy_all

    render "show"
  end

  private
  def set_pasokara
    @pasokara = Pasokara.find(params[:id])
  end
end
