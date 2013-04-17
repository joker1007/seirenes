class Favorite < ActiveRecord::Base
  belongs_to :user
  belongs_to :pasokara

  validates_presence_of :user_id, :pasokara_id
end
