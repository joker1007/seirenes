class FacetTagsController < ApplicationController
  SearchParameter = Pasokara::Searchable::SearchParameter # class alias

  def index
    keyword = params[:q].present? ? params[:q].split("\s").map{|word| "\"#{word}\""}.join(" ") : nil
    search = Pasokara.search_with_facet_tags(SearchParameter.new(keyword: keyword, tags: params[:filter_tags]))

    tag_keyword = params[:tagq].presence
    filtered_facet_tags = search.facet(:tags).rows.lazy.reject {|facet| facet.value.in?(Settings.stop_tag_words)}
    @facet_tags = tag_keyword ? filtered_facet_tags.select {|facet| facet.value[tag_keyword]}.take(30) : filtered_facet_tags.take(30)
  end
end

