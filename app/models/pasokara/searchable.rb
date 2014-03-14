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
    def search_with_facet_tags(search_parameter, facet_size: 50)
      query = Jbuilder.encode do |json|
        json.query do
          keyword_query(search_parameter.keyword, json)
        end

        query_filter(search_parameter.tags, search_parameter.user_id, json)

        facets(search_parameter.tags, search_parameter.user_id, facet_size, json)

        json.sort do
          search_parameter.order_by.each do |key, type|
            json.set! key, type.to_s
          end
        end
      end

      search(query).page(search_parameter.page).limit(search_parameter.per_page)
    end

    private

    def keyword_query(keyword, json)
      if keyword.present?
        json.match do
          json.title do
            json.query keyword
            json.operator "and"
          end
        end
      else
        json.match_all []
      end
    end

    def query_filter(tags, user_id, json)
      filters = []
      filters.concat Array(tags_proc(tags))
      filters.concat Array(user_id_proc(user_id))

      if filters.present?
        json.filter do
          json.bool do
            json.must do
              json.array! filters do |procedure|
                procedure.call(json)
              end
            end
          end
        end
      end
    end

    def facets(tags, user_id, facet_size, json)
      filters = []
      filters.concat Array(tags_proc(tags))
      filters.concat Array(user_id_proc(user_id))

      json.facets do
        json.tags do
          json.terms do
            json.field "tags"
            json.size facet_size
          end

          if filters.present?
            json.facet_filter do
              json.bool do
                json.must do
                  json.array! filters do |procedure|
                    procedure.call(json)
                  end
                end
              end
            end
          end
        end
      end
    end

    def tags_proc(tags)
      if tags.present?
        ->(json) {
          json.terms do
            json.tags tags
            json.execution "and"
          end
        }
      end
    end

    def user_id_proc(user_id)
      if user_id.present?
        ->(json) {
          json.term do
            json.user_ids user_id
          end
        }
      end
    end
  end
end
