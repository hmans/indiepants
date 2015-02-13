require 'rails_helper'

feature "rendering documents" do
  given!(:user) { create :user, local: true, host: 'foo.pants.dev', password: 'secret' }
  given!(:post) { create :pants_post, user: user, body: "I am a post!" }

  scenario do
    visit post.url
    expect(page).to have_content(post.body)

    # there should be a discovery tag linking at the JSON representation
    link = page.find('html>head>link[rel="pants-document"]', visible: false)
  end
end
