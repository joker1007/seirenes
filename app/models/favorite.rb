# == Schema Information
#
# Table name: favorites
#
#  id          :integer          not null, primary key
#  user_id     :integer          not null
#  pasokara_id :integer          not null
#  created_at  :datetime
#  updated_at  :datetime
#

class Favorite < ActiveRecord::Base
  belongs_to :user
  belongs_to :pasokara

  validates_presence_of :user_id, :pasokara_id
  validates_uniqueness_of :user_id, scope: [:pasokara_id]

  DEFAULT_PER_PAGE = 50
  paginates_per DEFAULT_PER_PAGE
end
