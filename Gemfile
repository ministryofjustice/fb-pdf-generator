source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.5'

gem 'httparty', '~> 0.17.1'
gem 'jwt', '~> 2.2'
gem 'pdfkit', '~> 0.8.4'
gem 'puma', '~> 4.3'
gem 'rails', '~> 6.0.1'
gem 'sentry-raven', '~> 2.12'
gem 'wkhtmltopdf-binary', '~> 0.12.5'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'pdf-reader'
  gem 'pry'
  gem 'pry-nav', '~> 0.3.0'
  gem 'pry-remote', '~> 0.1.8'
  gem 'rspec-rails'
  gem 'rubocop', '~> 0.76.0'
  gem 'rubocop-rspec', '~> 1.37'
  gem 'timecop', '~> 0.9.1'
  gem 'webmock', '~> 3.7'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.3'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'pdf-inspector', require: 'pdf/inspector'
end
