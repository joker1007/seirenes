class HistoriesController < ApplicationController
  def index
    @histories = History.includes(:pasokara).page(params[:page])
    respond_to do |format|
      format.html {render "pasokaras/index"}
      format.json
    end
  end
end
