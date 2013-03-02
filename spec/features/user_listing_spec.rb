require 'spec_helper'

feature "User Feature" do
  scenario "Listing User" do
    FactoryGirl.create(:user)
    visit users_path
    puts page.body
  end
end
