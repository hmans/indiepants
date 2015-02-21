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
end
