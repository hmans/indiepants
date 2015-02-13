require 'rails_helper'

describe Pants::Document do
  describe '#fetch!' do
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
              <p>Pants is awesome, Pants is great!</p>
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
          html: "<p>Pants is awesome, Pants is great!</p>",
          data: { foo: "bar" },
          tags: ["foo", "bar"],
          previous_urls: ["http://remote-host/old"],
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

        %w[url type title html data tags previous_urls published_at].each do |name|
          expect(document.send(name)).to eq(json[name])
        end
      end
    end

    context "when the remote document has a h-entry" do
      it "fetches the document from the h-entry"
    end

    context "when the remote document is simple HTML" do
      it "performs crazy magicks"
    end
  end
end


__END__
moooooo!
