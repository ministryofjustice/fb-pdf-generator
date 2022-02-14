source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.5'

gem 'httparty', '~> 0.20.0'
gem 'jwt', '~> 2.3'
gem 'metrics_adapter', '0.2.0'
gem 'pdfkit', '~> 0.8.4'
gem 'puma', '~> 5.6.2'
gem 'rails', '~> 6.1.4.6'
gem 'sentry-rails', '~> 5.1.0'
gem 'sentry-ruby', '~> 5.1.0'
gem 'wkhtmltopdf-binary', '~> 0.12.6'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'pdf-reader'
  gem 'pry'
  gem 'pry-nav', '~> 1.0.0'
  gem 'pry-remote', '~> 0.1.8'
  gem 'rspec-rails'
  gem 'rubocop', '~> 1.25.1'
  gem 'rubocop-rspec', '~> 2.8'
  gem 'timecop', '~> 0.9.4'
  gem 'webmock', '~> 3.14'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.8'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'pdf-inspector', require: 'pdf/inspector'
end
