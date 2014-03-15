# == Schema Information
#
# Table name: recorded_songs
#
#  id          :integer          not null, primary key
#  data        :string(255)
#  public_flag :boolean
#  user_id     :integer
#  pasokara_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class RecordedSong < ActiveRecord::Base
  belongs_to :user
  belongs_to :pasokara

  mount_uploader :data, RecordedDataUploader

  validates_presence_of :data
end
