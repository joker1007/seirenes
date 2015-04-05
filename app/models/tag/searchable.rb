module Tag::Searchable
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

    mapping do
      indexes :name, store: true, analyzer: "myNgramAnalyzer"
    end
  end
end
