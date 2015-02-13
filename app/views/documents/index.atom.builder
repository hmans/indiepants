atom_feed :language => 'en' do |feed|
  feed.title current_site.name

  documents = @documents.limit(20)
  feed.updated documents.maximum(:updated_at)
  render documents, feed: feed
end
