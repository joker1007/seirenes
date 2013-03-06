class Tag < ActiveRecord::Base
  has_many :taggings, dependent: :destroy

  validates_presence_of :name
  validates_uniqueness_of :name
  validates_length_of :name, maximum: 255
end
