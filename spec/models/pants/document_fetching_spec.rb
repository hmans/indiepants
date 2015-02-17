require 'rails_helper'

describe Pants::Document do
  describe '#fetch!' do
    before do
      stub_request(:get, "http://www.planetcrap.com/")
        .to_return(status: 200, body: "")
    end

    context "when the remote document is pants-document enabled" do
      let(:html_body) do
        <<-EOS
        <!DOCTYPE html>
        <html>
          <head>
            <title>PSA</title>
            <link href="/json" rel="pants-document" />
          </head>
          <body>
            <article class="h-entry">
              <p>Pants is awesome, Pants is great! <a href="http://www.planetcrap.com">PlanetCrap</a>, woohoo!</p>
            </article>
          </body>
        </html>
        EOS
      end

      let(:json) do
        {
          url: "http://remote-host/html",
          type: "pants.post",
          title: "PSA",
          html: %[<p>Pants is awesome, Pants is great! <a href="http://www.planetcrap.com">PlanetCrap</a>, woohoo!</p>],
          data: { foo: "bar" },
          tags: ["foo", "bar"],
          published_at: 12.days.ago.iso8601
        }.with_indifferent_access
      end

      before do
        stub_request(:get, "http://remote-host/html")
          .to_return(status: 200, body: html_body, headers: { "Content_Type": "text/html" })

        stub_request(:get, "http://remote-host/json")
          .to_return(status: 200, body: json.to_json, headers: { "Content_Type": "application/json" })
      end

      it "fetches the document via the provided pants-document JSON" do
        document = Pants::Document.new(url: "http://remote-host/html")
        expect(document.fetch!).to eq(:pants)

        %w[url type title html data tags published_at].each do |name|
          expect(document.send(name)).to eq(json[name])
        end
      end
    end

    context "when the remote document has a h-entry" do
      let(:html_body) do
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
            </article>
          </body>
        </html>
        EOS
      end

      before do
        stub_request(:get, "http://remote-host/html")
          .to_return(status: 200, body: html_body, headers: { "Content_Type": "text/html" })
      end

      it "fetches the document from the h-entry" do
        document = Pants::Document.new(url: "http://remote-host/html")
        expect(document.fetch!).to eq(:microformats)
        expect(document.html).to eq(%[<p>This is a post without pants-document JSON. <a href="http://www.planetcrap.com">PlanetCrap</a>, woohoo!</p>])
        expect(document.title).to eq("Public Service Announcement")
        expect(document.published_at).to eq("2015-01-22 19:22:13")
      end
    end

    context "when the remote document is simple HTML" do
      it "performs crazy magicks"
    end
  end
end
