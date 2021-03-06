module Pasokara::Searchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model

    settings index: {
      analysis: {
        analyzer:  {
          myNgramAnalyzer:   {
            tokenizer: "myNgramTokenizer",
            filter:    %w(lowercase),
          },
          myKeywordAnalyzer: {
            tokenizer: "keyword",
            filter:    %w(lowercase),
          },
        },
        tokenizer: {
          myNgramTokenizer: {
            type:        "nGram",
            token_chars: %w(letter digit symbol)
          },
        },
      },
    }

    mappings do
      indexes :title, store: true, analyzer: "myNgramAnalyzer", copy_to: "raw_title"
      indexes :raw_title, store: true, index: "not_analyzed"
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
  end

  def as_indexed_json(_options = {})
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

    def ==(other)
      return false unless other.is_a?(SearchParameter)

      keyword == other.keyword &&
        tags.sort == other.tags.sort &&
        page == other.page &&
        per_page == other.per_page &&
        order_by == other.order_by &&
        user_id == other.user_id
    end
  end

  module ClassMethods
    def search_with_facet_tags_query(search_parameter, facet_size: 50)
      Jbuilder.encode do |json|
        json.query do
          build_query(search_parameter.keyword, search_parameter.tags, search_parameter.user_id, json)
        end

        build_facets(facet_size, json)

        json.sort do
          search_parameter.order_by.each do |key, type|
            json.set! key, type.to_s
          end
        end
      end
    end

    def search_with_facet_tags(search_parameter, facet_size: 50)
      search_by(search_parameter) { search_with_facet_tags_query(search_parameter, facet_size: facet_size) }
    end

    def random_search_query(search_parameter)
      Jbuilder.encode do |json|
        json.query do
          json.function_score do
            json.query do
              build_query(search_parameter.keyword, search_parameter.tags, search_parameter.user_id, json)
            end
            json.random_score Object.new
          end
        end
      end
    end

    def random_search(search_parameter)
      search_by(search_parameter) { random_search_query(search_parameter) }
    end

    private

    def search_by(search_parameter, &query_builder)
      query = query_builder.call
      search(query).page(search_parameter.page).limit(search_parameter.per_page)
    end

    def build_query(keyword, tags, user_id, json)
      queries = []
      queries << keyword_proc(keyword)
      tags.each do |t|
        queries << tag_proc(t)
      end
      queries.concat Array(user_id_proc(user_id))

      json.bool do
        json.must do
          json.array! queries do |q|
            q.call(json)
          end
        end
      end
    end

    def build_facets(facet_size, json)
      json.facets do
        json.tags do
          json.terms do
            json.field "tags"
            json.size facet_size
          end
        end
      end
    end

    def keyword_proc(keyword)
      if keyword.present?
        ->(json) {
          json.constant_score do
            json.query do
              json.query_string do
                json.query keyword
                json.default_field "title"
                json.default_operator "and"
                json.use_dis_max false
              end
            end
            json.boost 1
          end
        }
      else
        ->(json) {
          json.match_all []
        }
      end
    end

    def tag_proc(tag)
      ->(json) {
        json.match do
          json.tags do
            json.query tag
          end
        end
      }
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
