module DocumentFetching
  extend ActiveSupport::Concern

  def fetch!
    # Check if we have a URL
    raise "no URL given" if url.blank?

    # Abort if we're local (no need to fetch)
    return false if local?

    # Load and parse the page
    doc = HTTParty.get(url).to_s
    page = Nokogiri::HTML(doc)

    fetch_from_pants_json(page) ||
      fetch_from_microformats(page) ||
      fetch_from_magic_extraction(page)
  end

  def fetch_from_pants_json(page)
    if link = page.css("head>link[rel=pants-document]")
      if pants_json_url = link.first.try(:[], "href")
        json = HTTParty.get(URI.join(url, pants_json_url))
        consume_json(json)
        :pants
      end
    end
  end

  def fetch_from_microformats(page)
    if h_entry = page.css('.h-entry').first
      self.html = h_entry.css('.e-content').children.to_s rescue nil
      self.published_at = h_entry.css('.dt-published').attr('datetime').to_s rescue nil
      :microformats
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

  def consume_json(json)
    # If this document already has a URL, check if it's equal to the URL
    # given in the JSON.
    raise "URL mismatch" if url.present? && json["url"] != url

    # Copy over the attributes that we consider safe.
    allowed_attributes = %w[url type title html data tags previous_urls published_at]
    self.attributes = json.slice(*allowed_attributes)
    self
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
