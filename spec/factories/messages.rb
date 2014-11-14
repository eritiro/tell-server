FactoryGirl.define do
  factory :message do
    association :from, factory: :user
    association :to, factory: :user
    text "MyString"
  end
end
