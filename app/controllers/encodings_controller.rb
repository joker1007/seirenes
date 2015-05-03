class EncodingsController < ApplicationController
  before_action :set_pasokara, only: [:show, :create]

  def show
    if @pasokara.movie_url.present?
      render json: {movie_url: @pasokara.movie_url, progress: nil}
    else
      redis = Redis::Namespace.new(:seirenes_pasokara_encoding, redis: Redis.new)
      progress = redis[@pasokara.id.to_s]
      render json: {movie_url: nil, progress: progress}
    end
  end

  def create
    @pasokara.encode_async
    render json: {encoding: true}
  end

  private
  def set_pasokara
    @pasokara = Pasokara.find(params[:pasokara_id])
  end
end
