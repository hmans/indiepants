concern :DocumentFetching do
  def fetch!
    # Check if we have a URL
    raise "no URL given" if url.blank?

    # Abort if we're local (no need to fetch)
    return false if local?

    # Load and parse the page
    Rails.logger.info "Fetching #{url}"
    doc = HTTParty.get(url, timeout: 10.seconds).to_s
    page = Nokogiri::HTML(doc)

    fetch_from_pants_json(page) ||
      fetch_from_microformats(page) ||
      fetch_from_magic_extraction(page)

  rescue StandardError => e
    Rails.logger.error "Error while fetching #{url}: #{e}"
    false
  end

  def fetch_from_pants_json(page)
    if link = page.css("head>link[rel=pants-document]")
      if pants_json_url = link.first.try(:[], "href")
        json = HTTParty.get(URI.join(url, pants_json_url))
        consume_json(json)
        populate_links_from(html)

        :pants
      end
    end
  end

  def fetch_from_microformats(page)
    if h_entry = page.at_css('.h-entry')
      self.html = h_entry.at_css('.e-content').try { inner_html.strip }
      self.title = h_entry.at_css('.p-name').try { text } || page.at_css('head>title').try { text }
      self.published_at = h_entry.at_css('.dt-published').try { attr('datetime') }
      populate_links_from(h_entry.inner_html)

      :microformats
    end
  end

  def fetch_from_magic_extraction(page)
    # TODO: apply some magic extraction algorithm!
    # self.html = page.inner_html
    self.title = page.at_css('head>title').try { text }

    :extraction
  end

  # Returns true if it's time to fetch the contents for this post.
  #
  def fetch?
    remote? && (new_record? || updated_at < 30.minutes.ago)
  end

  def consume_json(json)
    # If this document already has a URL, check if it's equal to the URL
    # given in the JSON.
    raise "URL mismatch" if url.present? && json["url"] != url

    # Copy over the attributes that we consider safe.
    allowed_attributes = %w[url type title html data tags published_at]
    self.attributes = json.slice(*allowed_attributes)
    self
  end

  class_methods do
    # Update/create a post given a URL.
    #
    def from_url(url, fetch: true)
      (at_url(url) || new(url: url)).tap do |post|
        if fetch && post.fetch?
          post.fetch!
          post.save!
        end
      end
    end
  end
end
