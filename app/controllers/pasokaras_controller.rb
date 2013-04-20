class PasokarasController < ApplicationController
  before_action :set_pasokara, only: [:show, :update, :unfavorite]

  SearchParameter = Pasokara::Searchable::SearchParameter # class alias

  def index
    if request.xhr?
      order_by = params[:order_by] ? params[:order_by].split(" ").map(&:to_sym) : [:created_at, :desc]
      search = Pasokara.search_with_facet_tags(SearchParameter.new(keyword: params[:q].presence, tags: params[:filter_tags], page: params[:page], order_by: [order_by], user_id: params[:user_id]))
      @pasokaras = search.results
      @tags = @pasokaras.flat_map{|p| p.tags}.uniq
    end
  end

  def show
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
