require 'rails_helper'

describe Pants::User do
  specify "has a valid default factory" do
    expect(build_stubbed(:user)).to be_valid
  end

  describe '#url' do
    before do
      subject.scheme = "http"
      subject.host = "foo.com"
    end

    it "returns a complete URL composed of the data stored with this user" do
      expect(subject.url).to eq("http://foo.com")
    end
  end

  describe '#url=' do
    it "splits the URL into its components and stores them with the user" do
      subject.url = "https://www.bar.com"
      expect(subject.scheme).to eq("https")
      expect(subject.host).to eq("www.bar.com")
    end
  end
end
