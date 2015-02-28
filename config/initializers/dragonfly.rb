require 'dragonfly'

class PantsDataStore
  def klass
    Pants::Binary
  end

  # Store the data AND meta, and return a unique string uid
  def write(content, opts={})
    instance = klass.create!(payload: content.data, meta: content.meta)
    instance.id
  end

  # Retrieve the data and meta as a 2-item array
  def read(uid)
    if instance = klass.where(id: uid).take
      [
        instance.payload,
        instance.meta
      ]
    else
      nil
    end
  end

  # Delete the specified binary resource
  def destroy(uid)
    klass.find(uid).destroy
  end
end


# Configure
Dragonfly.app.configure do
  plugin :imagemagick
  secret Rails.application.secrets.secret_key_base
  url_format "/media/:job/:name"
  datastore PantsDataStore.new
end

# Logger
Dragonfly.logger = Rails.logger

# Mount as middleware
Rails.application.middleware.use Dragonfly::Middleware

# Add model functionality
ActiveRecord::Base.extend Dragonfly::Model
ActiveRecord::Base.extend Dragonfly::Model::Validations
