class SongQueuesController < ApplicationController
  before_action :set_song_queue, only: [:show, :destroy]

  def index
    @song_queues = SongQueue.includes(:pasokara).page(params[:page])
    respond_to do |format|
      format.html {render "pasokaras/index"}
      format.json
    end
  end

  def show
    respond_to do |format|
      format.html {render "pasokaras/index"}
      format.json
    end
  end

  def create
    @pasokara = Pasokara.find(params[:pasokara_id])
    @song_queue = @pasokara.song_queues.create!
    render :show
  end

  def destroy
    @song_queue.destroy!
    render json: {meta: {deleted: true}}
  end

  private
  def set_song_queue
    @song_queue = SongQueue.find(params[:id])
  end
end
