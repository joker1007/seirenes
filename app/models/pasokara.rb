class Pasokara < ActiveRecord::Base
  include SimpleTaggable

  searchable do
    text :title
    string :tags, multiple: true do
      tags.map(&:name)
    end
    string :nico_vid
    integer :nico_view_count
    integer :nico_mylist_count
    text :nico_description
    time :nico_posted_at
    integer :duration
  end
end
