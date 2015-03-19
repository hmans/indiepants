FactoryGirl.define do
  factory :document, class: "Pants::Document" do
    user
    html "<p>Lorem Ipsum.</p>"
    sequence(:path) { |i| "/document-#{i}" }

    factory :remote_document do
      user { build(:remote_user) }
    end

    trait :with_stubs do
      after(:build) do |document|
        WebMock.stub_request :get, document.user.url
        WebMock.stub_request :get, document.url
      end
    end
  end
end
