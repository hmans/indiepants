module Pants
  class User < ActiveRecord::Base
    has_secure_password validations: false

    validates_presence_of :password,
      on: :create,
      if: :local?

    has_many :documents,
      dependent: :destroy

    has_many :webmentions,
      dependent: :destroy

    scope :local,  -> { where(local: true) }
    scope :remote, -> { where(local: false) }

    # Build a complete URL from the components stored with
    # this user record.
    #
    def url
      uri = URI("#{scheme}://#{host}")
      uri.to_s
    end

    # When setting the URL, split it into its component and store them.
    #
    def url=(v)
      uri = URI(v)
      self.scheme = uri.scheme
      self.host = uri.host
      uri
    end

    def remote?
      !local?
    end
  end
end
