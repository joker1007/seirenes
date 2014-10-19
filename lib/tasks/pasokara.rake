namespace :pasokara do
  desc "Arrange tags"
  task resave: [:environment] do
    Pasokara.find_each(&:save)
  end
end
