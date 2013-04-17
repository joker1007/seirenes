class FavoritesController < ApplicationController
  before_action :authenticate
  before_action :set_favorite, only: [:destroy]

  def index
    @pasokaras = current_user.pasokaras.page(params[:page])
    respond_to do |format|
      format.html {render "pasokaras/index"}
      format.json
    end
  end

  def create
    current_user.favorites.create(pasokara: Pasokara.find(params[:pasokara_id]))
    render json: {meta: {created: true}}
  end

  def destroy
    @favorite.destroy!
    render json: {meta: {deleted: true}}
  end

  private
  def set_favorite
    @favorite = Favorite.find(params[:id])
  end
end
