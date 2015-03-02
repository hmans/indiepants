concern :UserFetching do
  class FetchError < StandardError ; end

  included do
    before_validation do
      fetch! if fetch?
    end
  end

  def fetch!
    raise "Can't fetch local users" if local?

    if fetch?
      fetch = Fetch[url]

      if fetch.success? && data = fetch.user_data
        # Check if host has changed. Later on, we'll probably want to deal
        # with this in a more graceful manner.
        #
        if host != URI(data["url"]).host
          raise "Retrieved u-url doesn't match expected host #{host}."
        end

        # Assign updated data
        self.url = data["url"]
        consume(data)
        self
      else
        raise FetchError, "Couldn't fetch user data for #{url}. (#{fetch.response.code})"
      end
    end
  end

  def fetch?
    remote?
  end

  def consume(data)
    self.attributes = data.with_indifferent_access.slice(:name)
  end
end
