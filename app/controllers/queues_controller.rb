class QueuesController < ApplicationController
  def create
    @pasokara = Pasokara.find(params[:pasokara_id])
    @pasokara.song_queues.create!
  end
end
