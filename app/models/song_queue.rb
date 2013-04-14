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
