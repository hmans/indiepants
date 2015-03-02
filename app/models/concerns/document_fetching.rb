concern :DocumentFetching do
  class FetchError < StandardError ; end

  included do
    before_validation do
      fetch! if fetch?
    end
  end

  # Returns true if it's time to fetch the contents for this post.
  #
  def fetch?
    remote?
  end

  def fetch!
    if fetch?
      fetch = Fetch[url]

      if fetch.success? && data = fetch.document_data
        # Abort if URL host has changed unexpectedly. Later on, we'll want to
        # deal with this in a more graceful manner.
        if data['url'] && URI(data['url']).host != user.host
          raise "Retrieved u-url doesn't match expected host #{user.host}."
        end

        # Consume data
        consume(data)

        self
      else
        raise FetchError, "Couldn't fetch document data for #{url}. (#{fetch.response.code})"
      end
    end
  end
end
