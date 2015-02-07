require 'rails_helper'

feature "claiming a new site" do
  scenario do
    visit "http://foo.pants.dev/"

    expect(current_path).to eq("/setup")
    expect(page).to have_content("You're about to claim foo.pants.dev as your site.")
    fill_in "Name", with: "Mr. Foo"
    fill_in "Password", with: "secret123"

    expect { click_button "Create Site" }
      .to change { User.count }.by(1)

    expect(current_path).to eq("/")
    expect(User.where(host: "foo.pants.dev").count).to eq(1)
  end
end
