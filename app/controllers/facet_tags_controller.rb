class FacetTagsController < ApplicationController
  def index
    search = Pasokara.all_with_facet_tags
    @facet_tags = search.facet(:tags).rows
  end
end
