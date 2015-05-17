require 'rails_helper'

describe Fetch do
  subject { Fetch["http://remote-host/html"] }

  describe '#document_data' do
    let(:data) { subject.document_data }

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
          uid: "http://remote-host/html-uid",
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
        %w[url uid type title html data tags published_at].each do |name|
          expect(data[name]).to eq(json[name])
        end
      end
    end

    context "when the remote document has a h-entry" do
      before do
        stub_request(:get, "http://remote-host/html")
          .to_return(status: 200, body: html_document_with_hentry, headers: { "Content_Type": "text/html" })
      end

      it "fetches the document from the h-entry" do
        expect(data['html']).to eq(%[<p>This is a post without pants-document JSON. <a href="http://www.planetcrap.com">PlanetCrap</a>, woohoo!</p>])
        expect(data['title']).to eq("Public Service Announcement")
        expect(data['published_at']).to eq("2015-01-22 19:22:13")
        expect(data['uid']).to eq("http://remote-host/uid")
      end
    end

    context "when the remote document is simple HTML" do
      it "performs crazy magicks"
    end
  end

  describe '#user_data' do
    let(:data) { subject.user_data }

    before do
      stub_request(:get, "http://remote-host/html")
        .to_return(status: 200, body: html_body, headers: { "Content_Type": "text/html" })
    end

    context "when the remote document has a h-card" do
      let(:html_body) do
        <<-EOS
        <!DOCTYPE html>
        <html>
          <head>
            <title>Mr. Awesome</title>
          </head>
          <body>
            <div class="h-card">
              <a href="http://www.awesome.com/" class="u-url p-name">Mr. Awesome</a>
              <img src="/photo.jpg" class="u-photo">
            </div>
          </body>
        </html>
        EOS
      end

      it "fetches the document from the h-entry" do
        expect(data['url']).to eq("http://www.awesome.com/")
        expect(data['name']).to eq("Mr. Awesome")
        expect(data['photo_url']).to eq("http://remote-host/photo.jpg")
      end
    end

    context "when the remote document has an `application/json+ld` script tag" do
      let(:html_body) do
        <<-EOS
        <!DOCTYPE html>
        <html>
          <head>
            <title>Mr. Awesome</title>
            <script type="application/ld+json">
              {
                "author": {
                  "@type": "Person",
                  "name": "Mr. Awesome",
                  "image": "http://www.awesome.com/photo.png",
                  "url": "http://www.awesome.com/"
                }
              }
            </script>
          </head>
          <body>
            I'm Mr. Awesome.
          </body>
        </html>
        EOS
      end

      it "fetches the document from JSON-LD block" do
        expect(data['url']).to eq("http://www.awesome.com/")
        expect(data['name']).to eq("Mr. Awesome")
        expect(data['photo_url']).to eq("http://www.awesome.com/photo.png")
      end
    end

    context "when the remote document is simple HTML" do
      let(:html_body) do
        <<-EOS
        <!DOCTYPE html>
        <html>
          <head>
            <title>Mr. Awesome</title>
          </head>
          <body>
            I'm a very boring website.
          </body>
        </html>
        EOS
      end

      it "tries to wing it using whatever HTML it can extract" do
        expect(data['url']).to eq("http://remote-host/")
        expect(data['name']).to eq("Mr. Awesome")
        expect(data['photo_url']).to eq(nil)
      end
    end
  end
end
