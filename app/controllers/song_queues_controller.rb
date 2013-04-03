class SongQueuesController < ApplicationController
  before_action :set_song_queue, only: [:show, :destroy]

  def index
    @song_queues = SongQueue.includes(:pasokara).page(params[:page])
  end

  def show
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
