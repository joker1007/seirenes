module Pasokara::Searchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model

    settings index: {
      analysis: {
        analyzer: {
          myNgramAnalyzer: {
            tokenizer: "myNgramTokenizer",
            filter: %w(lowercase),
          },
          myKeywordAnalyzer: {
            tokenizer: "keyword",
            filter: %w(lowercase),
          },
        },
        tokenizer: {
          myNgramTokenizer: {
            type: "nGram",
            token_chars: %w(letter digit symbol)
          },
        },
      },
    }

    mappings do
      indexes :title, store: true, analyzer: "myNgramAnalyzer"
      indexes :tags, analyzer: "myKeywordAnalyzer"
      indexes :user_ids, analyzer: "myKeywordAnalyzer"
      indexes :nico_vid, analyzer: "myKeywordAnalyzer"
      indexes :nico_view_count, type: "integer"
      indexes :nico_mylist_count, type: "integer"
      indexes :nico_description, store: true, analyzer: "myNgramAnalyzer"
      indexes :nico_posted_at, type: "date"
      indexes :duration, type: "integer"
      indexes :created_at, type: "date"
    end

    __elasticsearch__.create_index!
  end

  def as_indexed_json(options = {})
    as_json(
      only: [:title, :nico_vid, :nico_view_count, :nico_mylist_count, :nico_description, :nico_posted_at, :duration, :created_at],
      methods: [:user_ids]
    ).merge("tags" => tags.pluck(:name))
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
      search(include: [:tags, :users, :recorded_songs]) do
        if search_parameter.keyword.present?
          fulltext "#{search_parameter.keyword}" do
            fields(:title)
            minimum_match "100%"
          end
        end

        search_parameter.tags.each do |tag_name|
          with(:tags, tag_name)
        end
        facet :tags, limit: -1, sort: :count

        with(:user_ids, search_parameter.user_id) if search_parameter.user_id

        paginate page: search_parameter.page, per_page: search_parameter.per_page
        search_parameter.order_by.each do |(attribute, direction)|
          order_by(attribute, direction)
        end
      end
    end
  end
end
