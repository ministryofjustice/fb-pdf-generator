source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.4'

gem 'httparty', '~> 0.17.1'
gem 'jwt', '~> 2.2'
gem 'puma', '~> 4.2'
gem 'rails', '~> 6.0.0'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails'
  gem 'rubocop', '~> 0.75.0'
  gem 'rubocop-rspec', '~> 1.36'
  gem 'webmock', '~> 3.7'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.3'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end
