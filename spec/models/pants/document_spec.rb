require 'rails_helper'

describe Pants::Document do
  it "has a valid default factory" do
    expect(build_stubbed(:document)).to be_valid
  end

  describe '#url' do
    let(:user) { create(:user, host: "foo.com") }
    subject { create(:document, user: user, path: "/bar") }

    it "returns the complete URL" do
      expect(subject.url).to eq("http://foo.com/bar")
    end
  end

  describe '#url=' do
    let!(:foo) { create(:user, host: "foo.com") }

    it "stores the path" do
      subject.url = "http://foo.com/bar"
      expect(subject.path).to eq("/bar")
    end

    it "assigns the correct user" do
      subject.url = "http://foo.com/bar"
      expect(subject.user).to eq(foo)
    end

    it "creates a new user if required" do
      subject.url = "http://bar.com/bar"
      expect(subject.user).to be_new_record
      expect(subject.user.host).to eq("bar.com")
      subject.save!
      expect(subject.user).to be_persisted
    end
  end

  describe '.at_url' do
    subject { create :document, path: '/foo', previous_paths: ['/bar'] }

    it "returns the document for the specified URL" do
      expect(Pants::Document.at_url(subject.url)).to eq(subject)
    end

    it "finds documents that previously held the URL" do
      expect(Pants::Document.at_url(URI.join(subject.url, '/bar'))).to eq(subject)
    end
  end
end
