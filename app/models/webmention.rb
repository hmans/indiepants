class Webmention < ActiveRecord::Base
  validates :user_id, :source, :target,
    presence: true

  validate :validate_source_links_to_target, on: :create

  def source_page
    @source_page ||= begin
      doc = HTTParty.get(source).to_s
      Nokogiri::HTML(doc)
    end
  end

  def source_link
    source_page.css("a[href]").find { |link| link["href"] == target }
  end

private

  def validate_source_links_to_target
    unless source_link.present?
      errors.add(:source, "contains no link to target")
    end
  end
end
