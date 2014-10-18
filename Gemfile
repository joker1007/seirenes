source 'https://rubygems.org'
source 'https://rails-assets.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', github: 'rails/rails'
gem 'arel', github: 'rails/arel'
gem 'rack', github: 'rack/rack'
gem 'rack-cache', '~> 1.2'
gem 'turbolinks', github: 'rails/turbolinks', branch: 'master'
gem 'i18n', github: 'svenfuchs/i18n', branch: 'master'

gem 'mysql2'

gem 'sprockets-rails',  github: "rails/sprockets-rails"
gem 'sass-rails', github: 'rails/sass-rails'
gem 'coffee-rails', github: 'rails/coffee-rails'
gem 'haml_coffee_assets', github: "netzpirat/haml_coffee_assets"
gem 'bootstrap-sass'
gem 'compass-rails'
gem 'coffee-rails-source-maps'
gem 'zurui-sass-rails'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby

gem 'uglifier', '>= 1.3.0'

gem 'jquery-turbolinks'
gem "nprogress-rails"

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder'

# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', group: :doc

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Use unicorn as the app server
gem 'unicorn'

gem "haml-rails"

gem "pry-rails"

gem "awesome_print"
gem "tapp"

gem "factory_girl_rails"
gem "kaminari"
gem "omniauth"
gem "omniauth-twitter"
gem "omniauth-facebook"
gem 'oj'
gem 'oj_mimic_json'

gem "faraday"
gem "faraday_middleware"

gem "nico_downloader", github: "joker1007/nico_downloader"
gem "simple_taggable", github: "joker1007/simple_taggable"

gem "settingslogic"

gem "thor"

gem 'elasticsearch-model', git: 'git://github.com/elasticsearch/elasticsearch-rails.git'
gem 'elasticsearch-rails', git: 'git://github.com/elasticsearch/elasticsearch-rails.git'
gem 'elasticsearch-extensions'

gem 'active_decorator'

gem 'carrierwave'
gem 'fog', '>= 1.12'

gem 'sidekiq'
gem 'sinatra', '>= 1.3.0', :require => nil
gem 'sidekiq-ffmpeg', github: "joker1007/sidekiq-ffmpeg"
gem 'redis'
gem 'redis-namespace'
gem 'redis-mutex'

gem 'celluloid'

gem "which_browser", :git => 'git://github.com/joker1007/which_browser.git'

gem "chronic_duration"

gem "clockwork"
gem "daemons"

gem "eye"

gem "non-stupid-digest-assets"

group :development do
  gem 'capistrano'
  gem 'capistrano-rbenv', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-rails', require: false

  gem "i18n_generators"

  gem "binding_of_caller"
  gem "better_errors"

  gem "annotate", github: "ctran/annotate_models"

  gem 'spring'
  gem 'spring-commands-rspec'

  gem 'quiet_assets'
  gem 'thin'

  gem 'bullet'
end

group :development, :test do
  gem "byebug"
  gem "pry-stack_explorer"

  gem "rspec", ">= 3.0.0.rc1"
  gem "rspec-rails", ">= 3.0.0.rc1"
  gem "transpec"
  gem "rspec-its"
  gem 'rspec-activemodel-mocks'

  gem "capybara", github: "jnicklas/capybara"
  gem "poltergeist"

  gem "launchy"

  gem "guard-rspec"
  gem "growl"

  gem "libnotify", :require => RUBY_PLATFORM.downcase =~ /linux/ ? "libnotify" : false
  gem "rb-inotify", :require => RUBY_PLATFORM.downcase =~ /linux/ ? "rb-inotify" : false
  gem "rb-fsevent", :require => RUBY_PLATFORM.downcase =~ /darwin/ ? "rb-fsevent" : false

  gem "teaspoon"

  gem "hirb"
  gem "hirb-unicode"
end

group :test do
  gem "minitest"
  gem "shoulda-matchers"
  gem "simplecov", :require => false
  gem "simplecov-rcov", :require => false
  gem "rspec-formatter-git_auto_commit", :github => "joker1007/rspec-formatter-git_auto_commit"
  gem "delorean"
  gem "database_cleaner"
  gem "coveralls"
  gem "fuubar", github: "thekompanee/fuubar"
end

