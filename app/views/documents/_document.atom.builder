feed.entry(document, url: document_url(document), id: "tag:#{document.host},2005:#{document.path}") do |entry|
  entry.url     document.url
  # entry.title   post.title

  # content
  entry.content document.html

  # author
  entry.author do |author|
    author.name document.user.name
    author.uri  document.user.url
  end
end
