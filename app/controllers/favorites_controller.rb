class FavoritesController < ApplicationController
  before_action :authenticate

  def index
    @pasokaras = current_user.pasokaras.includes(:tags, :recorded_songs).page(params[:page]).order("title asc")
      .includes([:tags, :users])
    @tags = @pasokaras.flat_map{|p| p.tags}.uniq

    render "pasokaras/index"
  end

  def show
    @pasokara = Pasokara.find(params[:id])
    respond_to do |format|
      format.json
    end
  end

  def create
    @pasokara = Pasokara.find(params[:pasokara_id])
    current_user.favorites.create(pasokara: @pasokara)
    render "pasokaras/show"
  end
end
