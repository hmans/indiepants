module Fetch
  extend self

  def response(url)
    Rails.logger.info "Fetching #{url}"
    HTTParty.get(url, timeout: 10.seconds)
  end

  def html(url)
    response(url).to_s
  end

  def nokogiri(url)
    Nokogiri::HTML(html(url))
  end
end
