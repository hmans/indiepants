class Pants::Post < ::Post
  store_accessor :data, :body

  validates :body,
    presence: true

  def generate_html
    Formatter.new(body).complete.to_s
  end

  def generate_slug
    body.truncate(80).parameterize
  end
end
