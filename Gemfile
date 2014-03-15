source 'https://rubygems.org'
source 'https://rails-assets.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.0.rc1'

gem 'mysql2'

gem 'sass-rails',   '~> 4.0.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'bootstrap-sass'
gem 'compass-rails'
gem 'zurui-sass-rails'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby

gem 'uglifier', '>= 1.3.0'

gem 'jquery-rails'
gem 'jquery-ui-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
gem 'jquery-turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '>= 1.0.1'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Use unicorn as the app server
gem 'unicorn'

# Deploy with Capistrano
#gem 'capistrano', group: :development
gem 'capistrano', group: :development
gem 'capistrano_colors', :require => false, :group => [:development]

gem "haml-rails"

group :development do
  gem "rails3-generators", :git => "git://github.com/indirect/rails3-generators.git", :group => [:development]
  gem "i18n_generators"

  gem "binding_of_caller"
  gem "better_errors"

  gem "annotate", github: "ctran/annotate_models"

  gem 'spring'
  gem 'spring-commands-rspec'

  gem 'quiet_assets'
end

group :development, :test do
  gem "rspec", "~> 2.11"
  gem "rspec-rails", "~> 2.11"

  gem "capybara"
  gem "poltergeist"

  gem "minitest"
  gem "launchy"

  gem "awesome_print"
  gem "tapp"

  gem "guard-rspec"
  gem "growl"

  gem "libnotify", :require => RUBY_PLATFORM.downcase =~ /linux/ ? "libnotify" : false
  gem "rb-inotify", :require => RUBY_PLATFORM.downcase =~ /linux/ ? "rb-inotify" : false
  gem "rb-fsevent", :require => RUBY_PLATFORM.downcase =~ /darwin/ ? "rb-fsevent" : false

  gem "teaspoon"

  gem "webmock", :require => false
  gem "vcr", :require => false

  gem "hirb"
  gem "hirb-unicode"
end

group :test do
  gem "shoulda-matchers"
  gem "turn", :require => false
  gem "simplecov", :require => false
  gem "simplecov-rcov", :require => false
  gem "rspec-formatter-git_auto_commit", :github => "joker1007/rspec-formatter-git_auto_commit"
  gem "delorean"
  gem "database_cleaner"
  gem "coveralls"
  gem "fuubar"
end

gem "pry-rails"
gem "pry-stack_explorer"
gem "byebug"

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

gem "settingslogic"

gem "thor"

gem 'elasticsearch-model', git: 'git://github.com/joker1007/elasticsearch-rails.git', branch: "more_intuitive_pagination"
gem 'elasticsearch-rails', git: 'git://github.com/elasticsearch/elasticsearch-rails.git'
gem 'elasticsearch-extensions'

gem 'active_decorator'

gem 'carrierwave'
gem 'fog', '>= 1.12'

gem 'resque'
gem 'resque-ffmpeg', github: "joker1007/resque-ffmpeg"

gem 'handlebars_assets'
gem 'spinjs-rails'

gem 'celluloid'

gem 'gritter'

gem "which_browser", :git => 'git://github.com/joker1007/which_browser.git'

gem "chronic_duration"

# rails-assets
gem 'rails-assets-jquery', require: false
gem 'rails-assets-jqueryui', require: false
gem 'rails-assets-spin.js'
gem 'rails-assets-lodash'
gem 'rails-assets-backbone'
gem 'rails-assets-backbone.marionette', '>= 1.6'
gem 'rails-assets-backbone.stickit'
