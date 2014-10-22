# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user, aliases: [:author] do
    sequence(:username) { |n| "john#{n}" }
    sequence(:email) { |n| "john#{n}@gmail.com" }
    password "1234"
    gender "male"

    factory :admin do
      admin true
    end
  end
end
