FactoryGirl.define do
  factory :notification do
    association :from, factory: :user
    association :to, factory: :user
    text "MyString"
    type "message"
  end
end
