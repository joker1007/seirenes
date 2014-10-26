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
# Indexes
#
#  index_favorites_on_pasokara_id  (pasokara_id)
#  index_favorites_on_user_id      (user_id)
#

class Favorite < ActiveRecord::Base
  belongs_to :user, required: true
  belongs_to :pasokara, required: true

  validates_uniqueness_of :user_id, scope: [:pasokara_id]

  DEFAULT_PER_PAGE = 50
  paginates_per DEFAULT_PER_PAGE
end
