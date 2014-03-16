# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :pasokara do
    title "ペガサス幻想"
    fullpath { (Rails.root + "spec/datas/testfile.mp4").to_s }
    sequence(:nico_vid) {|n| "sm999999#{n}"}
    nico_posted_at "2013-03-02 21:31:43"
    nico_view_count 1
    nico_mylist_count 1
    duration 125
    nico_description "description"
  end

  trait :seq do
    sequence(:fullpath) { |n| (Rails.root + "spec/datas/test#{"%04d" % n}.mp4").to_s }
  end

  trait :with_other_file do
    fullpath { (Rails.root + "spec/datas/test002.flv").to_s }
  end
end
