require 'rails_helper'

feature "creating a post" do
  given!(:user) { create :user, local: true, host: 'foo.pants.dev', password: 'secret' }

  scenario do
    visit "http://foo.pants.dev/"
    click_on "Login"

    fill_in "Password", with: "secret"
    click_button "Login"

    fill_in 'post_body', with: "Hi, I'm a post!\n\nI'm **Markdown formatted.**"
    expect { click_button "Create Post" }
      .to change { Post.count }.by(1)

    post = user.posts.latest.first

    expect(page.body).to include("<p>I’m <strong>Markdown formatted.</strong></p>")
    expect(current_url).to eq(post.url)
    expect(post.type).to eq('pants.post')
  end
end
