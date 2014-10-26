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
# Indexes
#
#  index_recorded_songs_on_pasokara_id  (pasokara_id)
#  index_recorded_songs_on_user_id      (user_id)
#

class RecordedSong < ActiveRecord::Base
  belongs_to :user, required: true
  belongs_to :pasokara, required: true

  mount_uploader :data, RecordedDataUploader

  validates_presence_of :data
end
