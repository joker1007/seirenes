class PlayersController < ApplicationController
  def show
    respond_to do |format|
      format.html {render "pasokaras/index"}
      format.json
    end
  end
end
