source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.0.beta1'

gem 'mysql2'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 4.0.0.beta1'
  gem 'coffee-rails', '~> 4.0.0.beta1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', platforms: :ruby

  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.0.1'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
gem 'capistrano', group: :development
gem 'capistrano_colors', :require => false, :group => [:development]

# To use debugger
# gem 'debugger'

gem "haml-rails"
gem "unicorn"

group :development do
  gem "rails3-generators", :git => "git://github.com/indirect/rails3-generators.git", :group => [:development]
  gem "i18n_generators"
end

group :development, :test do
  gem "rspec", "~> 2.11"
  gem "rspec-rails", "~> 2.11"
  # gem "spork", ">= 0.9.2"
  gem "spring", github: "jonleighton/spring"

  gem "capybara"
  gem "capybara-webkit"

  gem "minitest"
  gem "launchy"

  gem "awesome_print"
  gem "tapp"

  # gem "guard-spork"
  gem "guard-rspec"
  gem "parallel_tests"

  gem "pry-rails"
  gem "pry-remote"

  gem "libnotify", :require => RUBY_PLATFORM.downcase =~ /linux/ ? "libnotify" : false
  gem "rb-inotify", :require => RUBY_PLATFORM.downcase =~ /linux/ ? "rb-inotify" : false
  gem "ruby_gntp", :require => RUBY_PLATFORM.downcase =~ /linux/ ? "ruby_gntp" : false
  gem "rb-fsevent", :require => RUBY_PLATFORM.downcase =~ /darwin/ ? "rb-fsevent" : false

  gem "jasmine"
  gem "jasmine-headless-webkit"
  gem "jasmine-spec-extras", :git => "git://github.com/johnbintz/jasmine-spec-extras.git"
  gem "guard-jasmine-headless-webkit"

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
  # gem "database_cleaner", github: "bmabey/database_cleaner"
end

gem "factory_girl_rails"
gem "kaminari"
gem "omniauth"
gem "omniauth-twitter"
gem 'oj'

gem "faraday"
gem "faraday_middleware"
