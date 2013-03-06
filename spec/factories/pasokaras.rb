# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :pasokara do
    title "Title"
    fullpath { Rails.root + "spec/datas/test001.mp4"}
    md5_hash "hash"
    nico_vid "sm9999999"
    nico_posted_at "2013-03-02 21:31:43"
    nico_view_count 1
    nico_mylist_count 1
    duration 1
    nico_description "description"
  end
end
