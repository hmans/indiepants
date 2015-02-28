require 'dragonfly'

# Configure
Dragonfly.app.configure do
  plugin :imagemagick

  secret "eca8dd8250639a447bac9339c065c831112a1bf379b4a06652615d1165a7abae"

  url_format "/media/:job/:name"

  datastore :file,
    root_path: Rails.root.join('public/system/dragonfly', Rails.env),
    server_root: Rails.root.join('public')
end

# Logger
Dragonfly.logger = Rails.logger

# Mount as middleware
Rails.application.middleware.use Dragonfly::Middleware

# Add model functionality
ActiveRecord::Base.extend Dragonfly::Model
ActiveRecord::Base.extend Dragonfly::Model::Validations
