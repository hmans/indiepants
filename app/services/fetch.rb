class Fetch
  attr_reader :url

  delegate :success?, :not_found?,
    to: :response

  def initialize(url)
    @url = url
  end

  def uri
    @uri ||= URI(url)
  end

  def response
    @response ||= begin
      Rails.logger.info "Fetching #{url}"
      HTTParty.get(url, timeout: 10.seconds)
    end
  end

  def html
    @html ||= begin
      response.to_s
    end
  end

  def nokogiri
    @nokogiri ||= begin
      Nokogiri::HTML(html)
    end
  end

  def data
    @data ||= begin
      # Check if we have a URL
      raise "no URL given" if url.blank?

      # Load and parse the page
      page = nokogiri

      data = data_from_pants_json ||
        data_from_microformats ||
        data_from_magic_extraction

      data.with_indifferent_access
    rescue StandardError => e
      Rails.logger.error "Error while fetching #{url}: #{e}"
      false
    end
  end

  private

  def data_from_pants_json
    if link = nokogiri.css("head>link[rel=pants-document]")
      if pants_json_url = link.first.try(:[], "href")
        json = HTTParty.get(URI.join(url, pants_json_url))
        json
      end
    end
  end

  def data_from_microformats
    if h_entry = nokogiri.at_css('.h-entry')
      {
        html:  h_entry.at_css('.e-content').try { inner_html.strip },
        title: h_entry.at_css('.p-name').try { text } || page.at_css('head>title').try { text },
        published_at:  h_entry.at_css('.dt-published').try { attr('datetime') },
        uid:   h_entry.at_css('.u-uid').try { attr('href') }
      }
    end
  end

  def data_from_magic_extraction
    # TODO: apply some magic extraction algorithm!
    # self.html = page.inner_html
    {
      title: nokogiri.at_css('head>title').try { text }
    }
  end

  class << self
    def [](url)
      Fetch.new(url)
    end
  end
end
