FactoryGirl.define do
  factory :document, class: "Pants::Document" do
    user
    html "<p>Lorem Ipsum.</p>"
  end
end
