source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.3'

gem 'httparty', '~> 0.21.0'
gem 'jwt', '~> 2.7'
gem 'pdfkit', '~> 0.8.7'
gem 'puma', '~> 6.1.1'
gem 'rails', '~> 6.1.7.1', '< 7.0.0'
gem 'sentry-rails', '~> 5.8.0'
gem 'sentry-ruby', '~> 5.8.0'
gem 'wkhtmltopdf-binary', '~> 0.12.6'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'pdf-reader'
  gem 'pry'
  gem 'pry-nav', '~> 1.0.0'
  gem 'pry-remote', '~> 0.1.8'
  gem 'rspec-rails'
  gem 'rubocop', '~> 1.52.1'
  gem 'rubocop-rspec', '~> 2.22'
  gem 'timecop', '~> 0.9.6'
  gem 'webmock', '~> 3.18'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.9'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.1.0'
end

group :test do
  gem 'pdf-inspector', require: 'pdf/inspector'
end
