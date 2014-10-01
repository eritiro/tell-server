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

    trait :scan do
      event_type "scan"
    end

    trait :comment do
      event_type "comment"
    end
  end
end
