FactoryGirl.define do
  factory :notification do
    association :from, factory: :user
    association :to, factory: :user
    title "Emiliano"
    text "Hello"
    type "message"
  end
end
