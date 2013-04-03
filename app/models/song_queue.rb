class SongQueue < ActiveRecord::Base
  belongs_to :pasokara
  belongs_to :user

  paginates_per 100

  delegate :title, :thumbnail, to: :pasokara
end
