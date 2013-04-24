class FacetTagsController < ApplicationController
  SearchParameter = Pasokara::Searchable::SearchParameter # class alias

  def index
    keyword = params[:q].present? ? params[:q].split("\s").map{|word| "\"#{word}\""}.join(" ") : nil
    search = Pasokara.search_with_facet_tags(SearchParameter.new(keyword: keyword, tags: params[:filter_tags]))

    filters = %w(ニコニコカラオケDB ニコニコカラオケＤＢ VOCALOID ボカロカラオケDB ボカロカラオケＤＢ ニコカラ vocaloid 音楽 ﾆｺﾆｺカラオケDB 東方 カラオケ)
    tag_keyword = params[:tagq].presence
    filtered_facet_tags = search.facet(:tags).rows.lazy.reject {|facet| facet.value.in?(filters)}
    @facet_tags = tag_keyword ? filtered_facet_tags.select {|facet| facet.value[tag_keyword]}.take(50) : filtered_facet_tags.take(50)
  end
end

