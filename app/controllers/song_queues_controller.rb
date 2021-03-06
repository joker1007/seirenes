class SongQueuesController < ApplicationController
  before_action :set_song_queue, only: [:show, :update, :destroy]

  SearchParameter = Pasokara::Searchable::SearchParameter # class alias

  def index
    @song_queues = SongQueue.includes(:pasokara).page(params[:page])
  end

  def show
  end

  def create
    @pasokara = Pasokara.find(params[:pasokara_id])
    @song_queue = @pasokara.song_queues.create!
    render :show
  end

  def random
    keyword = params[:q].presence
    search_parameter = SearchParameter.new(keyword: keyword)
    @pasokara = Pasokara.random_search(search_parameter).records.sample
    @song_queue = @pasokara.song_queues.create!
    render :show
  end

  def update
    if params[:finish]
      @song_queue.finish!
    end
    render :show
  end

  def destroy
    @song_queue.destroy!
    respond_to do |format|
      format.html { redirect_to song_queues_url }
      format.json { render :show }
    end
  end

  private
  def set_song_queue
    @song_queue = SongQueue.find(params[:id])
  end
end
