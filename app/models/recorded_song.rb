class RecordedSong < ActiveRecord::Base
  belongs_to :user
  belongs_to :pasokara

  mount_uploader :data, RecordedDataUploader

  validates_presence_of :data
end
