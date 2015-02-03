FactoryGirl.define do
  factory :user do
    sequence(:name, 'A') { |n| "User #{n}" }
    host { name.parameterize + ".dev" }
  end
end
