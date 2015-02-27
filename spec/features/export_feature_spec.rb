require 'rails_helper'

feature "exporting all data" do
  given!(:user) { create :user, local: true, host: 'foo.pants.dev', password: 'secret' }
  given!(:posts) { create_list :pants_post, 10, user: user }

  scenario do
    login(user)

    click_link "Settings"
    click_link "export all your data"
    click_link "Export Data"

    expect(page.response_headers["Content-Disposition"])
      .to match(%r{^attachment; filename=foo-pants-dev-export})

    expect(json['user']).to eq(expected_user_json(user))
    expect(json['documents']).to eq(user.documents.map { |d| expected_document_json(d) })
  end
end
