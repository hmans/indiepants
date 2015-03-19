require 'rails_helper'

describe Pants::Document do
  let(:original) { build :remote_document, :with_stubs }

  context "with a UID" do
    before { original.uid = 'http://my/uid' }

    context "when there is another document with the same UID" do
      let!(:duplicate) do
        create :remote_document, :with_stubs, user: original.user, uid: original.uid
      end

      describe '#duplicates' do
        it "returns duplicate posts" do
          expect(original.duplicates).to eq([duplicate])
        end
      end

      it "removes the other document" do
        expect { original.save! }
          .to change { Pants::Document.where(id: duplicate.id).first }
          .from(duplicate).to(nil)
      end
    end
  end

  context "without a UID" do
    before { original.uid = nil }

    context "when there is another document with the same path" do
      let!(:duplicate) do
        create :remote_document, :with_stubs, user: original.user, path: original.path
      end

      describe '#duplicates' do
        it "returns duplicate posts" do
          expect(original.duplicates).to eq([duplicate])
        end
      end

      it "removes the other document" do
        expect { original.save! }
          .to change { Pants::Document.where(id: duplicate.id).first }
          .from(duplicate).to(nil)
      end
    end

    context "when there is no other document with the same path" do
      let!(:duplicate) do
        create :remote_document, :with_stubs, user: original.user
      end

      describe '#duplicates' do
        it "returns nothing" do
          expect(original.duplicates).to eq([])
        end
      end

      it "removes the other document" do
        expect { original.save! }
          .to_not change { Pants::Document.where(id: duplicate.id).first }
      end
    end
  end
end
