source 'https://rubygems.org'

# Core
ruby '2.2.1'
gem 'rails', github: 'rails/rails', branch: '4-2-1'
gem 'pg'
gem 'bcrypt', '~> 3.1.7'
gem 'puma'
# gem 'therubyracer', platforms: :ruby
gem 'responders'

# Frontend
gem 'sass-rails', '~> 5.0'
gem 'compass-rails'
gem 'coffee-rails', '~> 4.1.0'
gem 'jquery-rails'
gem 'slim-rails'
gem 'uglifier', '>= 1.3.0'
gem 'turbolinks'
gem 'slodown', github: 'hmans/slodown'
gem 'simple_form'
gem 'font-awesome-rails'

# Images and other binary data
gem 'dragonfly'

# Data
gem 'paranoia', '~> 2.0'

# HTTP & IndieWeb
gem 'httparty'
gem 'webmention'

# API
gem 'jbuilder', '~> 2.0'
gem 'yajl-ruby'


# Development
group :development, :test do
  gem 'pry-rails'
  gem 'spring', '~> 1.2.0'  # newer versions conflicted with slodown's git dependency
  gem 'spring-commands-rspec'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'ffaker'
  gem 'factory_girl_rails'
  gem 'rspec-rails'
  gem 'rspec-collection_matchers'
  gem 'capybara', require: false
  gem 'webmock', require: false
  gem 'foreman'
  gem 'quiet_assets'

  # Deployment
  # gem 'capistrano-rails'
end

# production only
group :production do
  gem 'rails_12factor'
  gem 'rack-cache'
end
