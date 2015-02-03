require 'rails_helper'

describe Post do
  subject { build_stubbed :post }

  it "has a valid default factory" do
    expect(subject).to be_valid
  end

  it "is not valid if URL doesn't match user's host" do
    subject.url = "http://foo-#{subject.user.host}/article.html"
    expect(subject).to_not be_valid
    expect(subject).to have(1).error_on(:url)
  end
end
