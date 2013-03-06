module SimpleTaggable
  extend ActiveSupport::Concern

  included do
    has_many :taggings, as: :taggable, dependent: :destroy
    has_many :tags, through: :taggings, source: :tag
  end

  def tag_list
    self.tags.pluck(:name)
  end

  def tag_list=(tag_words)
    self.tags = tag_words.map {|t| Tag.new(name: t)}
  end

  def add_tag(tag_word)
    self.tags << Tag.new(name: tag_word)
  end
end
