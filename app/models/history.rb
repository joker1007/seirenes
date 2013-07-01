class History < ActiveRecord::Base
  belongs_to :pasokara
  belongs_to :user

  paginates_per 500

  delegate :title, :thumbnail, :movie_mp4, :movie_webm, to: :pasokara

  default_scope -> {order("created_at DESC")}
end
