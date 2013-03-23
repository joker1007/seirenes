class EncodingsController < ApplicationController
  before_action :set_pasokara, only: [:show, :create]

  def show
    if @pasokara.movie_url.present?
      render json: {movie_url: @pasokara.movie_url}
    else
      head :ok
    end
  end

  def create
    @pasokara.encode_async
    head :ok
  end

  private
  def set_pasokara
    @pasokara = Pasokara.find(params[:pasokara_id])
  end
end
