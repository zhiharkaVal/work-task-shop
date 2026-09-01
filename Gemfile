source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '>= 8.1.3.1'
gem 'sqlite3', '>= 2.9.6'
gem 'puma', '>= 8.0.2'
gem 'sassc-rails', '~> 2.1', '>= 2.1.2'
gem 'bootstrap', '~> 5.3', '>= 5.3.5'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'will_paginate', '~> 3.1', '>= 3.1.6'

gem 'jquery-rails', '~> 4.6'
gem 'jquery-ui-rails', '>= 8.0'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'
gem 'devise', '>= 5.0.4'

group :development, :test do
  gem 'pry-byebug', '~> 3.4'
end

group :development do
  gem 'bundler-audit', '>= 0.9.3'
  gem 'web-console', '~> 4.2', '>= 4.2.1'
  gem 'listen', '~> 3.9'
  gem 'spring', '~> 4.3'
  gem 'spring-watcher-listen', '~> 2.1'
end

group :test do
  gem 'rails-controller-testing', '~> 1.0', '>= 1.0.5'
  gem 'mocha', '~> 1.2', '>= 1.2.1'
  gem 'shoulda', '~> 3.5'
  gem 'minitest-reporters', '~> 1.7', '>= 1.7.1'
  gem 'factory_bot', '~> 6.4', '>= 6.4.6'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
