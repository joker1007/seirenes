module SimpleTaggable
  extend ActiveSupport::Concern

  included do
    has_many :taggings, as: :taggable, dependent: :destroy
    has_many :tags, through: :taggings, source: :tag

    after_save :save_own_tags
  end

  module ClassMethods
    def tagged_with(*tags)
      joins(:tags).merge(Tag.named(*tags))
    end
  end

  def tag_list
    @tag_list ||= TagList.new(*tags.pluck(:name))
  end

  def tag_list=(*tag_words)
    @tag_list = TagList.new(*tag_words.flatten)
  end

  def add_tag(*tag_word)
    tag_list.add(*tag_word.flatten)
  end

  private
  def save_own_tags
    existing_tags = Tag.where(name: tag_list)
    list_tags = tag_list.to_tags
    new_tags = list_tags.reject {|t| existing_tags.include?(t)}
    add_tags = existing_tags.reject {|t| tags.include?(t)}

    old_tags = tags.reject {|t| list_tags.include?(t)}

    taggings.where(tag_id: old_tags).destroy_all
    self.tags.reload

    self.tags += add_tags
    self.tags += new_tags
  end
end
