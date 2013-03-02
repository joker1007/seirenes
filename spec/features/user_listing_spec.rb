require 'spec_helper'

feature "User Feature" do
  scenario "Listing User", js: true do
    visit users_path
    page.driver.render("test.png", full: true)
  end
end
