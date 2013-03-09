# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :pasokara do
    title "Title"
    fullpath { (Rails.root + "spec/datas/test001.mp4").to_s }
    md5_hash { SecureRandom.hex }
    sequence(:nico_vid) {|n| "sm999999#{n}"}
    nico_posted_at "2013-03-02 21:31:43"
    nico_view_count 1
    nico_mylist_count 1
    duration 125
    nico_description "description"
  end
end
