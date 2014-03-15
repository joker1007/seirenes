class HistoriesController < ApplicationController
  def index
    @histories = History.includes(:pasokara).page(params[:page])
  end
end
