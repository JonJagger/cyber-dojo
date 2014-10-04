source 'https://rubygems.org'

gem 'rails',        '3.2.3'
gem 'jquery-rails', '2.1.3'

gem 'sqlite3',      '1.3.7'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier',     '>= 1.0.3'
end

gem 'thin'
gem 'therubyracer'

group :test do
  gem 'rspec'
  gem 'shoulda-matchers'
  gem 'capybara'
  gem 'selenium-webdriver', '~> 2.38.0'
  gem 'faker'
  gem 'autotest-standalone'
  gem 'autotest-growl'
  gem 'approvals', '>= 0.0.7'
  gem 'cucumber'
  gem 'simplecov', '>= 0.7.1', :group => :test
end

# rspec-rails needs to be in the development group so that Rails generators work.
group :development, :test do
  gem 'rspec-rails'
  gem 'pry', '~> 0.9.9'
  gem 'pry-debugger'
end