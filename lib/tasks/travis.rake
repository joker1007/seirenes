desc "Travis CI"
task :travis do
  sh "bundle exec rake db:create db:migrate"
  sh "bundle exec rspec spec -t ~ffmpeg"
end
