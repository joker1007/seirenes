class Tag < ActiveRecord::Base
  has_many :taggings, dependent: :destroy

  validates_presence_of :name
  validates_uniqueness_of :name
  validates_length_of :name, maximum: 255

  scope :named, ->(*words) { where(name: words).uniq }

  def ==(object)
    super || (object.is_a?(Tag) && name == object.name)
  end

  def to_s
    name
  end
end
