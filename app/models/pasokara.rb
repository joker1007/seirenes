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
end
