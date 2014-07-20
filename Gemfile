source 'https://rubygems.org'
ruby '2.1.2'

gem 'rails', '4.1.4'
gem 'sass-rails'
gem 'haml-rails'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem 'compass-rails'
gem 'simple_form'
gem 'httparty'
gem 'spring',        group: :development

group :development, :test do
  gem 'sqlite3'
  gem 'pry-rails'
  gem 'pry-byebug'
  gem 'rspec-rails'
  gem 'teaspoon'
end

group :production do
  gem 'unicorn'
  gem 'rails_12factor'
  gem 'pg'
end

group :development do
  gem 'quiet_assets'
end

group :test do
  gem 'ffaker'
  gem 'factory_girl'
  gem 'shoulda-matchers'
  gem 'capybara'
  gem 'webmock'
  gem 'phantomjs'
end