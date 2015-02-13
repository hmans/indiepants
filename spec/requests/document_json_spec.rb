require 'rails_helper'

describe "requesting a document's JSON" do
  let!(:document) { create :document }

  specify do
    get pants_document_url(document, format: 'json', host: document.user.host)

    expect(response).to be_success
    expect(response.content_type).to eq('application/json')

    expect(json).to eq(expected_document_json(document))
  end
end
