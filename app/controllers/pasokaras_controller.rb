class PasokarasController < ApplicationController
  def index
    @pasokaras = Pasokara.page(params[:page])
  end
end
