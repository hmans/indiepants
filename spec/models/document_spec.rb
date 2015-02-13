require 'rails_helper'

describe Document do
  subject { build_stubbed :document }

  it "has a valid default factory" do
    expect(subject).to be_valid
  end

  it "is not valid if URL doesn't match user's host" do
    subject.url = "http://foo/article.html"
    subject.host = "bar"
    expect(subject).to_not be_valid
    expect(subject).to have(1).error_on(:url)
  end
end
