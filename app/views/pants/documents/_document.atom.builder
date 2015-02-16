feed.entry(document, url: document.url, id: "tag:#{document.user.host},2005:#{document.path}") do |entry|
  entry.url     document.url
  entry.title   document.title

  # content
  entry.content document.html

  # author
  entry.author do |author|
    author.name document.user.name
    author.uri  document.user.url
  end
end
