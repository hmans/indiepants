require 'rails_helper'

describe Pants::Document do
  describe '#fetch!' do
    subject { create :document }

    context "when the document is remote" do
      before do
        allow(subject).to receive(:remote?).and_return(true)
      end

      it "invokes Fetch to update its data" do
        data = { url: subject.url }

        expect(Fetch).to receive(:[])
          .with(subject.url)
          .and_return(double(document_data: data, success?: true))

        expect(subject).to receive(:consume)
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
end
