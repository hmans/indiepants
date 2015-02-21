require 'rails_helper'

describe Pants::Document do
  describe '#fetch!' do
    subject { create :document }

    context "when the document is remote" do
      before do
        allow(subject).to receive(:remote?).and_return(true)
      end

      it "invokes Fetch to update its data" do
        data = double

        expect(Fetch).to receive(:[])
          .with(subject.url)
          .and_return(double(data: data))

        expect(subject).to receive(:attributes=)
          .with(data)

        subject.fetch!
      end
    end

    context "when the document is local" do
      before do
        allow(subject).to receive(:remote?).and_return(false)
      end

      it "does nothing" do
        expect(Fetch).to_not receive(:[]).with(subject.url)
        subject.fetch!
      end
    end
  end

  describe '.from_url' do
    let(:user) { create :user, host: "alice" }
    let(:document) { create :document, user: user }

    context "when the URL is local" do
      it "retrieves the post from the database" do
        expect(Pants::Document.from_url(document.url)).to eq(document)
      end
    end

    context "when the URL is remote" do
      before do
        stub_request(:get, "http://bob/foo")
          .to_return(status: 200, body: html_document_with_hentry)
      end

      it "looks for the correct post to update (or creates a new one)" do
        expect { Pants::Document.from_url("http://bob/foo") }
          .to change { Pants::Document.count }.by(1)
      end
    end
  end
end
