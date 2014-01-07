source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.2'

# Use jdbcsqlite3 as the database for Active Record
gem 'activerecord-jdbcmysql-adapter', platform: :jruby
gem 'mysql2', platform: :ruby

gem 'friendly_id', '~> 5.0.2'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier' #, '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyrhino', platform: :jruby
gem 'therubyracer', platform: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

gem 'devise', '~> 3.2.2'

gem 'ledermann-rails-settings', :require => 'rails-settings'

gem 'font-awesome-rails', '~> 4.0.3.0'

gem 'puma', '~> 2.7.1'

gem 'fog'

gem 'typhoeus'

gem 'faraday'

gem 'figaro'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

group :development do
  gem 'guard-minitest'
  gem 'guard-jasmine'
  gem 'guard-bundler'
  gem 'ffi'
  gem 'rb-inotify', :require => false
  gem 'rb-fsevent', :require => false
  gem 'rb-fchange', :require => false
end

group :test, :development do
  gem 'minitest-rails'
  gem 'factory_girl_rails'
  gem 'database_cleaner'
  gem 'jasminerice', :git => 'https://github.com/bradphelan/jasminerice.git'
  gem 'jasmine'
end
