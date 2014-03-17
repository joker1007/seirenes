# == Schema Information
#
# Table name: histories
#
#  id          :integer          not null, primary key
#  pasokara_id :integer
#  user_id     :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class History < ActiveRecord::Base
  belongs_to :pasokara
  belongs_to :user

  paginates_per 500

  delegate :title, :thumbnail, :movie_mp4, :movie_webm, to: :pasokara

  default_scope -> {order("created_at DESC")}
end
