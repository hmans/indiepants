require 'rails_helper'

describe Pants::Document do
  context "when saving" do
    subject { build :document }
    let(:other_document) { create :document }

    it "automatically populates its outgoing links" do
      subject.html = %[Here's a <a href="#{other_document.url}" rel="foo">link</a>!]

      expect { subject.save! }.to change { Pants::Link.count }.by(1)
      link = Pants::Link.newest.take
      expect(link.source).to eq(subject)
      expect(link.target.url).to eq(other_document.url)
      expect(link.rel).to eq("foo")
    end

    it "doesn't create entries for unknown local targets" do
      subject.html = %[Here's a link to <a href="#{subject.user.url}">myself</a>!]
      expect { subject.save! }.to_not change { Pants::Link.count }
    end

    it "doesn't create entries for remote targets" do
      subject.html = %[Here's a link to <a href="http://www.planetcrap.com/">a remote site</a>!]
      expect { subject.save! }.to_not change { Pants::Link.count }
    end
  end
end
