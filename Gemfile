source 'https://rubygems.org'

# Core
ruby '2.2.0'
gem 'rails', '4.2.0'
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

# Data
gem 'paranoia', '~> 2.0'

# HTTP & IndieWeb
gem 'httparty'

# API
# gem 'jbuilder', '~> 2.0'


# Development
group :development, :test do
  gem 'pry-rails'
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'factory_girl_rails'
  gem 'rspec-rails'
  gem 'rspec-collection_matchers'
  gem 'capybara'
  gem 'foreman'
  gem 'quiet_assets'

  # Deployment
  # gem 'capistrano-rails'
end

# production only
group :production do
  gem 'rails_12factor'
end
