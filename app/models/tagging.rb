class Tagging < ActiveRecord::Base
  belongs_to :tag
  belongs_to :taggable, polymorphic: true
  belongs_to :tagger, polymorphic: true

  validates_presence_of :tag_id

  validates_uniqueness_of :tag_id, :scope => [ :taggable_type, :taggable_id, :tagger_id, :tagger_type ]
end
