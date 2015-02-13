class Document < ActiveRecord::Base
  acts_as_paranoid

  include DocumentTypeSupport
  include DocumentFetching

  scope :latest, -> { order("created_at DESC") }

  belongs_to :user,
    foreign_key: "host",
    primary_key: "host"

  before_validation do
    if local?
      # Publish new posts right away
      self.published_at = Time.now

      # Render HTML
      self.html = generate_html

      # Make sure a slug is available
      self.slug ||= generate_unique_slug

      # build the default URL
      self.url = generate_url
    end

    # Remember previous URLs
    if persisted? && url_changed?
      self.previous_urls << url_was
    end
  end

  validate :validate_url_matches_host

  validates :url,
    presence: true,
    uniqueness: true

  validates :slug,
    presence: true,
    uniqueness: { scope: :host },
    format: /\A[a-zA-Z0-9_-]+\Z/,
    if: -> { local? }

  def validate_url_matches_host
    if url && URI(url).host != host
      errors.add(:url, "doesn't match host")
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

  # Generate a unique slug by adding a numerical, incremental suffix
  # if the generated_slug is already taken.
  #
  def generate_unique_slug
    slug = generate_slug
    candidate = slug
    i = 1
    while user.documents.where(slug: candidate).any?
      i += 1
      candidate = "#{slug}-#{i}"
    end
    candidate
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

  def local?
    user.try(:local?)
  end

  def remote?
    !local?
  end

  def url=(v)
    uri = URI(v)
    self.host = uri.host
    self.path = uri.path

    write_attribute(:url, v)
  end
end
