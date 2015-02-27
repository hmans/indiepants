module FeatureHelpers
  def login(user)
    visit user.url
    click_on "Login"
    fill_in "Password", with: user.password
    click_button "Login"
  end

  def json
    @json ||= JSON.parse(page.body)
  end
end
