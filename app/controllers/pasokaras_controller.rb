class PasokarasController < ApplicationController
  def index
    @pasokaras = Pasokara.page(params[:page])
    @tags = Tag.where(id: @pasokaras.flat_map {|p| p.tag_ids.uniq})
  end

  def show
    @pasokara = Pasokara.find(params[:id])
  end
end
