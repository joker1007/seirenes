# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :download_list do
    sequence(:url) {|n| "http://www.test.dummy/list/#{n}"}
    download true
  end
end
