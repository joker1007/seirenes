class Pasokara < ActiveRecord::Base
  include SimpleTaggable

  searchable do
    text :title, stored: true
    string :title_sort do
      title
    end
    string :tags, multiple: true, stored: true do
      tags.map(&:name)
    end
    string :nico_vid, stored: true
    integer :nico_view_count, trie: true
    integer :nico_mylist_count, trie: true
    text :nico_description, stored: true
    time :nico_posted_at, trie: true
    integer :duration, trie: true
  end

  mount_uploader :thumbnail, ThumbnailUploader
  mount_uploader :movie_mp4, MovieUploader
  mount_uploader :movie_webm, MovieUploader

  paginates_per 100

  include CreateMethods

  def encode_async(format = :mp4)
    Resque.enqueue(EncodeJob, fullpath, (Rails.root + "tmp/#{SecureRandom.hex}.#{format}").to_s, {"id" => id}, format)
  end
end
