module PostFetching
  extend ActiveSupport::Concern

  def fetch!
    return false if local?

    # Let's analyze the page a little.
    doc = HTTParty.get(url).to_s
    page = Nokogiri::HTML(doc)

    fetch_from_pants_json(page) ||
      fetch_from_microformats(page) ||
      fetch_from_magic_extraction(page)

    # Success!
    true
  end

  def fetch_from_pants_json(page)
    # if pants_json_url = page.css("head>link[rel=pants]").first.try(:[], "href")
    #   # TODO: fetch JSON and copy it into this record
    # end
  end

  def fetch_from_microformats(page)
    if h_entry = page.css('.h-entry').first
      self.html = h_entry.css('.e-content').children.to_s rescue nil
      self.published_at = h_entry.css('.dt-published').attr('datetime').to_s rescue nil
      true
    end
  end

  def fetch_from_magic_extraction(page)
    # TODO: apply some magic extraction algorithm!
  end

  # Returns true if it's time to fetch the contents for this post.
  #
  def fetch?
    new_record? || (remote? && updated_at < 30.minutes.ago)
  end

  module ClassMethods
    def from_url(url)
      where(url: url).first_or_initialize.tap do |post|
        if post.fetch?
          post.fetch!
          post.save!
        end
      end
    end
  end
end
