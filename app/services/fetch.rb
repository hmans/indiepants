class Fetch
  attr_reader :uri, :original_uri

  delegate :success?, :not_found?,
    to: :response

  def initialize(url)
    @uri = @original_uri = URI(url)
    response
  end

  def url
    uri.to_s
  end

  def original_url
    original_uri.to_s
  end

  def response
    @response ||= begin
      Rails.logger.info "Fetching #{url}"
      response = HTTParty.get(uri, timeout: 10.seconds)
      @uri = response.request.last_uri
      response
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

  def document_data
    @document_data ||= begin
      data = document_data_from_pants_json ||
        document_data_from_microformats ||
        document_data_from_magic_extraction

      data.try(:with_indifferent_access)
    rescue StandardError => e
      Rails.logger.error "Error while fetching document at #{url}: #{e}"
      false
    end
  end

  def user_data
    @user_data ||= begin
      data = user_data_from_pants_json ||
        user_data_from_microformats ||
        user_data_from_json_ld ||
        user_data_from_magic_extraction

      data = data.with_indifferent_access

      # Expand relative URLs
      %w[url photo_url].each do |key|
        if data[key].present?
          data[key] = URI.join(url, data[key]).to_s
        end
      end

      data
    rescue StandardError => e
      Rails.logger.error "Error while fetching user at #{url}: #{e}"
      false
    end
  end

  private

  concerning :DocumentFetching do
    def document_data_from_pants_json
      if link = nokogiri.css("head>link[rel=pants-document]")
        if pants_json_url = link.first.try(:[], "href")
          Fetch[URI.join(url, pants_json_url)].response
        end
      end
    end

    def document_data_from_microformats
      if h_entry = nokogiri.at_css('.h-entry')
        {
          html:  h_entry.at_css('.e-content').try { inner_html.strip },
          title: h_entry.at_css('.p-name').try { text } || page.at_css('head>title').try { text },
          published_at:  h_entry.at_css('.dt-published').try { attr('datetime') },
          uid:   h_entry.at_css('.u-uid').try { attr('href') }
        }
      end
    end

    def document_data_from_magic_extraction
      # TODO: apply some magic extraction algorithm!
      # self.html = page.inner_html
      {
        title: nokogiri.at_css('head>title').try { text }
      }
    end
  end

  concerning :UserFetching do
    def user_data_from_pants_json
      # not implemented -- we may not need it
    end

    def user_data_from_microformats
      if h_card = nokogiri.at_css('.h-card')
        {
          name:      h_card.at_css('.p-name').try { text },
          url:       h_card.at_css('.u-url').try { attr('href') },
          photo_url: h_card.at_css('.u-photo').try { attr('src') || attr('href') }
        }
      end
    end

    def user_data_from_json_ld
      # It's pretty simple at the moment, for example there are no checks for
      # the right JSON schema.  It works and as long as we don't encounter any
      # issues with this "dumb" solution adding more structural checks just
      # feels like preparing for hypothetical situations.
      if json_string = nokogiri.at_css('script[type="application/ld+json"]').try { text }
        json_ld = JSON.parse(json_string)

        if author = json_ld['author']
          {
            name: author['name'],
            url: author['url'],
            photo_url: author['image']
          }
        end
      end
    end

    def user_data_from_magic_extraction
      {
        name: nokogiri.at_css('title').try { text } || uri.host,
        url:  '/'
      }
    end
  end

  class << self
    def [](url)
      Fetch.new(url)
    end
  end
end
