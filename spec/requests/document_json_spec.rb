require 'rails_helper'

describe "GET /pants/documents/:id.json" do
  let!(:document) { create :document }

  specify do
    get pants_document_url(document, format: 'json', host: document.user.host)

    expect(response).to be_success
    expect(response.content_type).to eq('application/json')

    expect(json).to eq(expected_document_json(document))
  end
end

describe "GET /pants/documents.json" do
  let!(:user) { create :user }
  let!(:documents) { create_list :document, 10, user: user }

  specify do
    get pants_documents_url(format: 'json', host: user.host)

    expect(response).to be_success
    expect(response.content_type).to eq('application/json')

    expect(json['total']).to eq(10)
    expect(json['documents']).to eq(user.documents.map { |d| expected_document_json(d) })
  end
end
