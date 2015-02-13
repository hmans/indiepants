class User < ActiveRecord::Base
  has_secure_password

  has_many :posts,
    foreign_key: "host",
    primary_key: "host"

  has_many :webmentions,
    dependent: :destroy

  scope :local, -> { where(local: true) }
  scope :remote, -> { where(local: false) }

  validate :validate_host_matches_url

  before_validation :set_default_url

  def set_default_url
    self.url ||= "http://#{host}" if host.present?
  end

  def validate_host_matches_url
    if url.present? && URI(url).host != host
      errors.add(:host, "does not match URL")
    end
  end

  def remote?
    !local?
  end
end
