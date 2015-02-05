class Post < ActiveRecord::Base
  include PostTypeSupport

  scope :latest, -> { order("created_at DESC") }

  belongs_to :user,
    foreign_key: "host",
    primary_key: "host"

  before_validation do
    # Make sure a slug is available
    self.slug ||= generate_slug
  end

  before_create do
    # If this post is being created by a local, hosted user, there's
    # some extra stuff we'll want to do.
    #
    if user.local?
      # Publish new posts right away
      self.published_at = Time.now

      # Render HTML
      self.html = generate_html

      # build the default URL
      self.url = generate_url
    end
  end

  before_update do
    if user.local?
      # Update HTML
      self.html = generate_html

      # Update URL
      self.url = generate_url
      if url_changed?
        self.previous_urls << url_was
      end
    end
  end

  validate :validate_url_matches_host
  validates :slug,
    presence: true,
    uniqueness: true,
    format: /\A[a-zA-Z0-9_-]+\Z/


  def validate_url_matches_host
    if url && user && URI(url).host != user.host
      errors.add(:url, "doesn't match user's host")
    end
  end

  def generate_html
    # By default, just set #html to itself. Of course, this method is
    # expected to be overloaded in child classes. Duh!
    #
    html
  end

  def generate_slug
    SecureRandom.hex(6)
  end

  def generate_url
    dt = published_at || created_at || Time.now

    uri = URI(user.url)
    uri.path = [nil,
      dt.year.to_s.rjust(4, '0'),
      dt.month.to_s.rjust(2, '0'),
      dt.day.to_s.rjust(2, '0'),
      slug].join("/")

    uri.to_s
  end
end
