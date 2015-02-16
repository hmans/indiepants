require 'rails_helper'

describe "requesting a site's ATOM feed" do
  let!(:user) { create :user }
  let!(:documents) { create_list :document, 5, user: user }

  before do
    get pants_documents_url(format: 'atom', host: user.host)
  end

  it "returns a working ATOM feed" do
    expect(response).to be_success
    expect(response.content_type).to eq('application/atom+xml')
  end

  it "returns the correct data"
end
