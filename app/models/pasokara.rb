class Pasokara < ActiveRecord::Base
  validates_presence_of :title, :fullpath
  validates_uniqueness_of :fullpath
  validates_uniqueness_of :nico_vid, allow_nil: true

  include SimpleTaggable
  include Searchable

  mount_uploader :thumbnail, ThumbnailUploader
  mount_uploader :movie_mp4, MovieUploader
  mount_uploader :movie_webm, MovieUploader

  paginates_per 100

  include CreateMethods

  def movie_url(format = :mp4)
    send("movie_#{format}").url
  end

  def encode_async(format = :mp4)
    if movie_url(format).blank?
      Resque.enqueue(EncodeJob, fullpath, (Rails.root + "tmp/#{SecureRandom.hex}.#{format}").to_s, {"id" => id}, format)
    end
  end
end
