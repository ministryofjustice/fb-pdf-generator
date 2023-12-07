source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.2.2'

gem 'httparty', '~> 0.21.0'
gem 'jwt', '~> 2.7'
gem 'pdfkit', '~> 0.8.7'
gem 'puma', '~> 6.4.0'
gem 'rails', '~> 7.0.6'
gem 'sentry-rails', '~> 5.14'
gem 'sentry-ruby', '~> 5.14'
gem 'wkhtmltopdf-binary', '~> 0.12.6'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'pdf-reader'
  gem 'pry'
  gem 'pry-nav', '~> 1.0.0'
  gem 'pry-remote', '~> 0.1.8'
  gem 'rspec-rails'
  gem 'rubocop'
  gem 'rubocop-rspec'
  gem 'webmock', '~> 3.19'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.9'
end

group :test do
  gem 'pdf-inspector', require: 'pdf/inspector'
  gem 'simplecov'
  gem 'simplecov-console', require: false
end
