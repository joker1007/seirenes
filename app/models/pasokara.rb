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

  class << self
    def create_by_movie_info(movie_info)
      md5_hash = File.open(movie_info.path, "rb:ASCII-8BIT") {|f| Digest::MD5.hexdigest(f.read(300 * 1024))}
      Pasokara.create(
        title: movie_info.title,
        fullpath: movie_info.path,
        md5_hash: md5_hash,
        duration: movie_info.duration,
        nico_vid: movie_info.vid,
        nico_view_count: movie_info.view_count,
        nico_mylist_count: movie_info.mylist_count,
        nico_posted_at: movie_info.posted_at,
        nico_description: movie_info.description
      )
    end
  end
end
