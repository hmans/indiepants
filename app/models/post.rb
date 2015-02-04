class Post < ActiveRecord::Base
  attr_accessor :url_builder

  scope :latest, -> { order("created_at DESC") }

  belongs_to :user,
    foreign_key: "host",
    primary_key: "host"

  before_create do
    # If this post is being created by a local, hosted user, there's
    # some extra stuff we'll want to do.
    #
    if user.local?
      self.slug = generate_slug

      # Publish new posts right away
      self.published_at = Time.now

      # build the default URL
      self.url = generate_url

      # Render HTML
      self.body_html = generate_html
    end
  end

  validate :validate_url_matches_host

  def validate_url_matches_host
    if url && user && URI(url).host != user.host
      errors.add(:url, "doesn't match user's host")
    end
  end

  def generate_html
    Formatter.new(body).complete.to_s
  end

  def generate_slug
    body.truncate(20).parameterize
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
