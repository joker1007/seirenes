module Tag::Searchable
  extend ActiveSupport::Concern

  included do
    searchable do
      text :name, stored: true
      string :name_sort, stored: true do
        name
      end
    end
  end
end
