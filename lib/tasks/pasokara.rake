namespace :pasokara do
  desc "Arrange tags"
  task :resave => [:environment] do
    Pasokara.find_each do |pasokara|
      pasokara.save
    end
  end
end
