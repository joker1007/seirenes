module Pasokara::Searchable
  extend ActiveSupport::Concern

  included do
    searchable do
      text :title, stored: true
      string :title_sort do
        title
      end
      string :tags, multiple: true, stored: true do
        tags.map(&:name)
      end
      string :user_ids, multiple: true, stored: true do
        users.pluck(:id)
      end
      string :nico_vid, stored: true
      integer :nico_view_count, trie: true
      integer :nico_mylist_count, trie: true
      text :nico_description, stored: true
      time :nico_posted_at, trie: true
      integer :duration, trie: true
      time :created_at, trie: true
    end
  end

  class SearchParameter
    attr_reader :keyword, :tags, :page, :per_page, :order_by, :user_id
    def initialize(keyword: nil, tags: nil, page: 1, per_page: 50, order_by: [[:created_at, :desc]], user_id: nil)
      @keyword = keyword
      @tags = tags || []
      @page = page || 1
      @per_page = per_page.to_i
      @order_by = order_by
      @user_id = user_id
      freeze
    end
  end

  module ClassMethods
    def search_with_facet_tags(search_parameter)
      search(include: [:tags, :users]) do
        fulltext "\"#{search_parameter.keyword}\"" if search_parameter.keyword.present?
        search_parameter.tags.each do |tag_name|
          with(:tags, tag_name)
        end
        facet :tags

        with(:user_ids, search_parameter.user_id) if search_parameter.user_id

        paginate page: search_parameter.page, per_page: search_parameter.per_page
        search_parameter.order_by.each do |(attribute, direction)|
          order_by(attribute, direction)
        end
      end
    end
  end
end
