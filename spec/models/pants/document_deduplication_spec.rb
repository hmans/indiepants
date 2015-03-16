require 'rails_helper'

describe Pants::Document do
  let(:original) { build :document }

  context "with a UID" do
    before { original.uid = 'http://my/uid' }

    context "when there is another document with the same UID" do
      let!(:duplicate) { create :document, user: original.user, uid: original.uid }

      describe '#duplicates' do
        it "returns duplicate posts" do
          expect(original.duplicates).to eq([duplicate])
        end
      end

      xit "removes the other document" do
        expect { original.save! }
          .to change { duplicate.destroyed? }
      end
    end
  end

  context "without a UID" do
    before { original.uid = nil }

    context "when there is another document with the same path" do
      it "removes the other document"
    end

    context "when there is no other document with the same path" do
      it "does nothing"
    end
  end
end
