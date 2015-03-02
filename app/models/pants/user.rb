module Pants
  class User < ActiveRecord::Base
    include UserFetching

    has_secure_password validations: false

    store_accessor :data, :custom_css, :photo_uid

    dragonfly_accessor :photo

    validates :password,
      if: :local?, on: :create,
      length: { within: 6..40 },
      presence: true

    has_many :documents,
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

    def photo_thumbnail
      photo.try { thumb("300x300#", format: "jpg") }
    end

    def merge_with!(user)
      # TODO: implement. :-)
      Rails.logger.warn "merge_with called for #{self.host}, but no merging implemented yet."
      destroy
    end

    class << self
      def [](host)
        where(host: host).take
      end

      def for_url(url)
        where(host: URI(url).host).first_or_initialize.tap do |user|
          user.url = url
        end
      end
    end
  end
end
