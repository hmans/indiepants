class Post < ActiveRecord::Base
  attr_accessor :url_builder

  scope :latest, -> { order("created_at DESC") }

  belongs_to :user,
    foreign_key: "host",
    primary_key: "host"

  before_create do
    # default URL to UID-style URL if no URL is given.
    self.url ||= "http://#{host}/#{id}"
  end

  def generate_html
    Formatter.new(body).complete.to_s
  end

  def generate_slug
    body.truncate(20).parameterize
  end
end
