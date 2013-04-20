class FavoritesController < ApplicationController
  before_action :authenticate

  def index
    @pasokaras = current_user.pasokaras.page(params[:page]).order("title asc")
      .includes([:tags, :users])
    @tags = @pasokaras.flat_map{|p| p.tags}.uniq

    render "pasokaras/index"
  end

  def create
    @pasokara = Pasokara.find(params[:pasokara_id])
    current_user.favorites.create(pasokara: @pasokara)
    render "pasokaras/show"
  end
end
