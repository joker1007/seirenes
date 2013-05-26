# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :recorded_song do
    data "MyString"
    public_flag true
    user nil
    pasokara nil
  end
end
