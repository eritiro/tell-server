# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :event do
    event_type "registration"
    user

    trait :landing do
      event_type "landing"
      user nil
      ip "1.2.3.4"
    end

    trait :registration do
      event_type "registration"
    end

    trait :search do
      event_type "search"
    end

    trait :attend do
      event_type "attend"
    end

    trait :chat do
      event_type "chat"
    end
  end
end
