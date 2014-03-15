# == Schema Information
#
# Table name: tags
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Tag < ActiveRecord::Base
  has_many :taggings, dependent: :destroy

  validates_presence_of :name
  validates_uniqueness_of :name
  validates_length_of :name, maximum: 255

  scope :named, ->(*words) { where(name: words).uniq }

  include Searchable

  def ==(object)
    super || (object.is_a?(Tag) && name == object.name)
  end

  def to_s
    name
  end
end
