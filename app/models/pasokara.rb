# == Schema Information
#
# Table name: pasokaras
#
#  id                :integer          not null, primary key
#  title             :string(255)      not null
#  fullpath          :string(255)      not null
#  nico_vid          :string(20)
#  nico_posted_at    :datetime
#  nico_view_count   :integer          default(0), not null
#  nico_mylist_count :integer          default(0), not null
#  duration          :integer
#  nico_description  :string(700)
#  thumbnail         :string(255)
#  movie_mp4         :string(255)
#  movie_webm        :string(255)
#  created_at        :datetime
#  updated_at        :datetime
#

require "shellwords"

class Pasokara < ActiveRecord::Base
  has_many :song_queues
  has_many :favorites
  has_many :users, through: :favorites
  has_many :recorded_songs

  validates_presence_of :title, :fullpath
  validates_uniqueness_of :fullpath
  validates_uniqueness_of :nico_vid, allow_nil: true

  include ::SimpleTaggable
  include ::Thumbnailable
  include Searchable

  mount_uploader :thumbnail, ThumbnailUploader
  mount_uploader :movie_mp4, MovieUploader
  mount_uploader :movie_webm, MovieUploader

  DEFAULT_PER_PAGE = 50
  paginates_per DEFAULT_PER_PAGE
  FFMPEG = `which ffmpeg`.chomp.freeze

  include CreateMethods

  def movie_url(format = :mp4)
    send("movie_#{format}").url
  end

  def encode_async(format = :mp4)
    if movie_url(format).blank?
      EncodeJob.perform_async(fullpath, (Rails.root + "tmp/#{SecureRandom.hex}.#{format}").to_s, {"id" => id}, format)
    end
  end

  def favorited_by?(user)
    users.include?(user)
  end

  def fetch_duration
    ffmpeg = IO.popen("ffmpeg -i #{fullpath.shellescape} 2>&1")
    ffmpeg.read =~ /Duration:(.*?),/
    if duration.blank?
      update(duration: ChronicDuration.parse($1.strip).to_i)
    end
    duration
  end
end
