FactoryGirl.define do
  factory :post do
    user
    html "<p>Lorem Ipsum.</p>"
  end
end
