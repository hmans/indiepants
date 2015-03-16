FactoryGirl.define do
  factory :document, class: "Pants::Document" do
    user
    html "<p>Lorem Ipsum.</p>"
    sequence(:path) { |i| "/document-#{i}" }
  end
end
