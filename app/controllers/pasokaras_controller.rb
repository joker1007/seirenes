class PasokarasController < ApplicationController
  def index
    search = Pasokara.all_with_facet_tags(page: params[:page])
    @pasokaras = search.results
    @tags = @pasokaras.flat_map{|p| p.tags}.uniq
  end

  def show
    @pasokara = Pasokara.find(params[:id])
  end
end
