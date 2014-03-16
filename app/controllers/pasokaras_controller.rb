class PasokarasController < ApplicationController
  before_action :set_pasokara, only: [:show, :update, :unfavorite]
  before_action :trim_filter_tags_param, only: [:index]

  SearchParameter = Pasokara::Searchable::SearchParameter # class alias

  def index
    order_by = params[:order_by].try(:split, " ").try(:map, &:to_sym) || [:created_at, :desc]
    keyword = params[:q].presence
    search_parameter = SearchParameter.new(
      keyword: keyword,
      tags: params[:filter_tags],
      page: params[:page],
      order_by: [order_by]
    )
    @search = Pasokara.search_with_facet_tags(search_parameter)
    @pasokaras = @search.records.includes(:tags)
    @facets = @search.response["facets"]["tags"]["terms"]
  end

  def show
  end

  private

  def set_pasokara
    @pasokara = Pasokara.find(params[:id])
  end

  def trim_filter_tags_param
    params[:filter_tags].try(:reject!, &:blank?)
  end
end
