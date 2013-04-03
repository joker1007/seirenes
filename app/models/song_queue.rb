class SongQueue < ActiveRecord::Base
  belongs_to :pasokara
  belongs_to :user
end
