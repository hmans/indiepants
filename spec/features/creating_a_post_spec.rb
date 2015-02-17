require 'rails_helper'

feature "creating a post" do
  given!(:user) { create :user, local: true, host: 'foo.pants.dev', password: 'secret' }

  scenario do
    visit "http://foo.pants.dev/"
    click_on "Login"

    fill_in "Password", with: "secret"
    click_button "Login"

    fill_in 'document_body', with: "Hi, I'm a post!\n\nI'm **Markdown formatted.**"
    expect { click_button "Create Post" }
      .to change { Pants::Document.count }.by(1)

    document = user.documents.newest.first

    # The document's type should be set to the default pants.post
    expect(document.type).to eq('pants.post')

    # The rendered page should include a rendered version of the post's Markdown
    expect(page.body).to include("<p>I’m <strong>Markdown formatted.</strong></p>")

    # Are we seeing the correct URL?
    expect(current_url).to eq(document.url)
  end
end
