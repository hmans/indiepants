concern :DocumentFetching do
  # Returns true if it's time to fetch the contents for this post.
  #
  def fetch?
    remote?
  end

  def fetch!
    if remote? && data = Fetch[url].data
      self.attributes = data
    end
  end

  class_methods do
    # Update/create a post given a URL.
    #
    def from_url(url)
      user  = Pants::User[URI(url).host]

      # For local users, just do a database lookup.
      if user.try(:local?)
        find_by_url(url)

      # For everybody else, fetch the data.
      else
        fetch = Fetch[url]

        if fetch.success? && data = fetch.data
          if user
            # If data contains a UID, look up the document by UID.
            doc = user.documents.where(uid: data['uid']).take if data['uid'].present?

            # Otherwise, look up the document by its URL.
            doc ||= user.documents.where(path: fetch.uri.path).take
          end

          # Otherwise, create a new document.
          doc ||= Pants::Document.new

          # Apply attributes
          doc.url = url     # The URL may have changed due to redirects
          doc.consume(data) # This also may contain a new URL
          doc.save!
          doc
        else
          # The document could not be loaded due to errors (404 et al).
          Rails.logger.error "Tried to load a document for URL #{url}, but failed. (#{fetch.response.code})"
          nil
        end
      end
    end
  end
end
