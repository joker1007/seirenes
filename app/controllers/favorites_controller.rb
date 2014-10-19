class FavoritesController < ApplicationController
  before_action :authenticate
  before_action :trim_filter_tags_param, only: [:index]

  def index
    order_by = params[:order_by].try(:split, " ").try(:map, &:to_sym) || [:created_at, :desc]
    search_parameter = Pasokara::Searchable::SearchParameter.new(
      tags: params[:filter_tags],
      page: params[:page],
      order_by: [order_by],
      user_id: current_user.id
    )
    @search = Pasokara.search_with_facet_tags(search_parameter)
    @pasokaras = @search.records.eager_load(:tags, :favorites, :users)
    @facets = @search.response["facets"]["tags"]["terms"]

    render "pasokaras/index"
  end

  def create
    @pasokara = Pasokara.find(params[:pasokara_id])
    @favorite = current_user.favorites.create!(pasokara: @pasokara)
    render :show
  end

  def destroy
    @favorite = current_user.favorites.find(params[:id])
    @favorite.destroy

    render :show
  end
end
