atom_feed :language => 'en' do |feed|
  feed.title current_site.name

  posts = @posts.limit(20)
  feed.updated posts.maximum(:updated_at)
  render posts, feed: feed
end
