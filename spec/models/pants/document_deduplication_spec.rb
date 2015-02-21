require 'rails_helper'

describe Pants::Document do
  describe "#find_original" do
    subject { create(:document) }

    context "when another document has the same UID" do
      let!(:original) { create(:document, uid: subject.uid, user: subject.user) }

      it "returns the original document" do
        expect(subject.find_original).to eq(original)
      end
    end

    context "when no other document has the same UID" do
      it "returns nothing" do
        expect(subject.find_original).to be_blank
      end
    end
  end

  describe ".from_url" do
    subject { create(:document) }
    before  { subject.user.update_attributes(local: false) }

    context "when another document has the same UID" do
      let!(:original) { create(:document, user: subject.user, uid: subject.uid, path: '/original' ) }

      it "returns the original document" do
        stub_request(:get, subject.url)
        stub_request(:get, original.url)
        expect(Pants::Document.from_url(subject.url)).to eq(original)
      end
    end

    context "when no other document has the same UID" do
      it "returns the document" do
        stub_request(:get, subject.url)
        expect(Pants::Document.from_url(subject.url)).to eq(subject)
      end
    end
  end
end
