concern :DocumentLinks do
  included do
    has_many :outgoing_links,
      class_name: "Pants::Link",
      as: "source",
      dependent: :destroy

    has_many :incoming_links,
      class_name: "Pants::Link",
      as: "target",
      dependent: :destroy

    after_save do
      if html_changed? || title_changed? || path_changed?
        Background.go { populate_links! }
      end
    end
  end

  def populate_links!
    # Remember these for later
    marked_for_deletion = outgoing_links.pluck(:id)

    # create new links depending on content
    Nokogiri::HTML(html).css('a, link').each do |el|
      # Find an existing document matching the given URL, or create
      # a new, temporary one (we're not saving.)
      target = Pants::Document.find_by_url(el['href']) || Pants::Document.new(url: el['href'])
      link   = Pants::Link.where(source: self, target: target).first_or_initialize

      # Analyze the actual HTML link
      classes   = el['class'].try(:split) || []
      rels      = el['rel'].try(:split) || []
      link.rels = []

      if classes.include?("u-in-reply-to") || rels.include?('in-reply-to')
        link.rels << "reply"
      end

      if classes.include?("u-like-of")
        link.rels << "like"
      end

      if classes.include?("u-repost-of")
        link.rels << "repost"
      end

      # We're only interested in links to existing local documents.
      if target.local? && target.persisted?
        link.target = target
        link.save!

        # We don't need to delete this one
        marked_for_deletion.delete(link.id)
      elsif local? && target.remote?
        # Send a webmention, then discard this link.
        send_webmention(target.url)
      end
    end

    # Let's delete those that are still marked for deletion
    if marked_for_deletion.any?
      outgoing_links.where(id: marked_for_deletion).destroy_all
    end
  end

  def send_webmention(target)
    if endpoint = Webmention::Client.supports_webmention?(target)
      Webmention::Client.send_mention(endpoint, url, target)
    end
  end
end
