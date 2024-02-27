source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.2.2'

gem 'httparty', '~> 0.21'
gem 'jwt', '~> 2.7'
gem 'pdfkit', '~> 0.8.7'
gem 'puma', '~> 6.4'
gem 'rails', '~> 7.0.8'
gem 'sentry-rails', '~> 5.14'
gem 'sentry-ruby', '~> 5.14'
gem 'wkhtmltopdf-binary', '~> 0.12.6'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'pdf-reader'
  gem 'pry'
  gem 'pry-nav'
  gem 'pry-remote'
  gem 'rspec-rails'
  gem 'rubocop'
  gem 'rubocop-rspec'
  gem 'webmock'
end

group :development do
  gem 'listen'
end

group :test do
  gem 'pdf-inspector', require: 'pdf/inspector'
  gem 'simplecov'
  gem 'simplecov-console', require: false
end
