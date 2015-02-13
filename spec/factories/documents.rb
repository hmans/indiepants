FactoryGirl.define do
  factory :document do
    user
    html "<p>Lorem Ipsum.</p>"
  end
end
