class PasokarasController < ApplicationController
  def index
    Pasokara.page(params[:page])
  end
end
