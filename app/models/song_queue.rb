class SongQueue < ActiveRecord::Base
  belongs_to :pasokara
  belongs_to :user

  paginates_per 100

  delegate :title, :thumbnail, :movie_mp4, :movie_webm, to: :pasokara

  after_create :encode_async

  private
  def encode_async
    pasokara.encode_async
  end
end
