# == Schema Information
#
# Table name: song_queues
#
#  id          :integer          not null, primary key
#  pasokara_id :integer
#  user_id     :integer
#  created_at  :datetime
#  updated_at  :datetime
#
# Indexes
#
#  index_song_queues_on_pasokara_id  (pasokara_id)
#  index_song_queues_on_user_id      (user_id)
#

class SongQueue < ActiveRecord::Base
  belongs_to :pasokara
  belongs_to :user

  paginates_per 100

  delegate :title, :thumbnail, :movie_mp4, :movie_webm, to: :pasokara

  after_create :encode_async

  def finish!
    self.class.transaction do
      History.create(pasokara: pasokara, user: user)
      destroy!
    end
  end

  private
  def encode_async
    pasokara.encode_async
  end
end
