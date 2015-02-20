require 'rails_helper'

describe Pants::Document do
  context "when saving" do
    subject { build :document }
    let(:other_document) { create :document }
    let(:newest_link) { Pants::Link.newest.take }

    it "automatically populates its outgoing links" do
      subject.html = %[Here's a <a href="#{other_document.url}" class="u-in-reply-to">link</a>!]

      expect { subject.save! }.to change { Pants::Link.count }.by(1)
      expect(newest_link.source).to eq(subject)
      expect(newest_link.target.url).to eq(other_document.url)
      expect(newest_link.rels).to eq(["reply"])
    end

    it "correctly detects a.u-in-reply-to replies" do
      subject.html = %[Here's a <a href="#{other_document.url}" class="u-in-reply-to">link</a>!]
      subject.save!
      expect(newest_link.rels).to eq(["reply"])
    end

    it "correctly detects link[rel=in-reply-to] replies" do
      subject.html = %[<link rel="in-reply-to" href="#{other_document.url}">]
      subject.save!
      expect(newest_link.rels).to eq(["reply"])
    end

    it "correctly detects a.u-like-of likes" do
      subject.html = %[I like <a href="#{other_document.url}" class="u-like-of">this article</a>!]
      subject.save!
      expect(newest_link.rels).to eq(["like"])
    end

    it "correctly detects a.u-repost-of reposts" do
      subject.html = %[I like <a href="#{other_document.url}"
                       class="u-repost-of">this article</a> so much,
                       I'm reposting it!]
      subject.save!
      expect(newest_link.rels).to eq(["repost"])
    end

    it "doesn't create entries for unknown local targets" do
      subject.html = %[Here's a link to <a href="#{subject.user.url}">myself</a>!]
      expect { subject.save! }.to_not change { Pants::Link.count }
    end

    it "doesn't create entries for remote targets" do
      subject.html = %[Here's a link to <a href="http://www.planetcrap.com/">a remote site</a>!]

      # We're expecting to send a webmention to the referenced site
      expect(subject).to receive(:send_webmention).with("http://www.planetcrap.com/")

      # We're not expecting local links to change
      expect { subject.save! }.to_not change { Pants::Link.count }
    end
  end
end
