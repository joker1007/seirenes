# == Schema Information
#
# Table name: taggings
#
#  id            :integer          not null, primary key
#  tag_id        :integer
#  taggable_id   :integer
#  taggable_type :string(255)
#  tagger_id     :integer
#  tagger_type   :string(255)
#  created_at    :datetime
#

class Tagging < ActiveRecord::Base
  belongs_to :tag
  belongs_to :taggable, polymorphic: true
  belongs_to :tagger, polymorphic: true

  validates_presence_of :tag_id

  validates_uniqueness_of :tag_id, :scope => [ :taggable_type, :taggable_id, :tagger_id, :tagger_type ]
end
