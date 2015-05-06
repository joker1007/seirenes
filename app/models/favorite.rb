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

  after_create :update_pasokara_index
  after_destroy :update_pasokara_index

  private

  def update_pasokara_index
    self.pasokara.tapp.__elasticsearch__.update_document
  end
end
