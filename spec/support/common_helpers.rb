module CommonHelpers
  def html_document_with_hentry
    <<-EOS
    <!DOCTYPE html>
    <html>
      <head>
        <title>PSA</title>
      </head>
      <body>
        <article class="h-entry">
          <h3 class="p-name">Public Service Announcement</h3>
          <time class="dt-published" datetime="2015-01-22 19:22:13">22.01.15 19:22</time>
          <div class="e-content">
            <p>This is a post without pants-document JSON. <a href="http://www.planetcrap.com">PlanetCrap</a>, woohoo!</p>
          </div>
          <a href="http://remote-host/uid" class="u-uid">Permalink</a>
        </article>
      </body>
    </html>
    EOS
  end

  def expected_user_json(user)
    {
      name: user.name,
      url:  user.url
    }.with_indifferent_access
  end

  def expected_document_json(document)
    {
      url: document.url,
      uid: document.uid,
      type: document.type,
      title: document.title,
      html: document.html,
      data: document.data,
      tags: document.tags,
      meta: document.meta,
      previous_paths: document.previous_paths,
      published_at: document.published_at.iso8601
    }.with_indifferent_access
  end
end
