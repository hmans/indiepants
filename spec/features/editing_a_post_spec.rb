require 'rails_helper'

feature "creating a post" do
  given!(:user) { create :user, local: true, host: 'foo.pants.dev', password: 'secret' }
  given!(:post) { create :pants_post, user: user, body: "I'm a post!" }

  scenario do
    visit "http://foo.pants.dev/"
    click_on "Login"

    fill_in "Password", with: "secret"
    click_button "Login"

    visit post.url
    old_post_url = post.url
    expect(page.body).to have_content("I’m a post!")

    # Let's change this post's slug.
    click_on "Edit this Post"
    fill_in "Slug", with: "new-slug"
    click_on "Update Post"

    expect(current_path).to include("new-slug")

    # Now let's see if the old URL still redirects to the new one.
    visit old_post_url
    expect(current_path).to include("new-slug")
  end
end
