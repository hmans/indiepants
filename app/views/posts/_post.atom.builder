feed.entry(post, url: post_url(post), id: "tag:#{post.host},2005:#{post.slug}") do |entry|
  entry.url     post.url
  # entry.title   post.title

  # content
  entry.content post.html

  # author
  entry.author do |author|
    author.name post.user.name
    author.uri post.user.url
  end
end
