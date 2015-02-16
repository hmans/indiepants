FactoryGirl.define do
  factory :user, class: "Pants::User" do
    sequence(:name, 'A') { |n| "User #{n}" }
    host { name.parameterize + ".dev" }
    scheme "http"
    password "secret"
    local true
  end

  factory :remote_user, parent: :user do
    local false
  end
end
