require 'rails_helper'

describe "webmention requests" do
  let!(:document) { create :document }

  describe 'POST /pants/webmentions' do
    context "when the correct parameters are given" do
      it "is successful" do
        stub_request(:get, "http://www.foo.com/foo")

        post pants_webmentions_url(host: document.user.host),
          source: "http://www.foo.com/foo",
          target: document.url

        expect(response).to be_success
      end
    end

    context "when source is missing" do
      before do
        post pants_webmentions_url(host: document.user.host),
          target: document.url
      end

      it "returns 400 Bad Request" do
        expect(response).to be_bad_request
      end
    end

    context "when target is missing" do
      before do
        post pants_webmentions_url(host: document.user.host),
          source: "http://www.foo.com/foo"
      end

      it "returns 400 Bad Request" do
        expect(response).to be_bad_request
      end
    end
  end
end
