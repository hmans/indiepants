require 'rails_helper'

describe Pants::User do
  subject { build_stubbed(:user) }

  specify "has a valid default factory" do
    expect(subject).to be_valid
  end

  specify "is not valid if host differs from URL" do
    subject.url = "http://foo.com"
    subject.host = "bar.com"
    expect(subject).to_not be_valid
    expect(subject).to have(1).error_on(:host)
  end
end
