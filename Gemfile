# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.2'

gem 'azure-storage', require: false
gem 'bootsnap', '>= 1.4.2', require: false
gem 'cocoon'
gem 'devise', github: 'heartcombo/devise'
gem 'image_processing', '~> 1.2'
gem 'jbuilder', '~> 2.7'
gem 'omniauth'
gem 'omniauth-github'
gem 'omniauth-rails_csrf_protection'
gem 'omniauth-vkontakte'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 4.1'
gem 'pundit'
gem 'rails', '~> 6.1'
gem 'redis'
gem 'rest-client'
gem 'sass-rails', '>= 6'
gem 'sidekiq'
gem 'simple_form'
gem 'slim'
gem 'turbolinks', '~> 5'
gem 'webpacker', '~> 4.0'

group :development, :test do
  gem 'annotate'
  gem 'brakeman'
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'dotenv-rails'
  gem 'factory_bot_rails'
  gem 'rails-controller-testing'
  gem 'rspec-rails'
end

group :development do
  gem 'letter_opener'
  gem 'listen', '~> 3.2'
  gem 'rubocop', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
end

group :test do
  gem 'capybara'
  gem 'capybara-email'
  gem 'launchy'
  gem 'selenium-webdriver'
  gem 'shoulda-matchers', '~> 4.0'
  gem 'webdrivers'
  gem 'webmock'
end
