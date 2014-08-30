# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :location do
    name "FunnyPizza"
    address "102 Apple st."
    phone "1-101-1011"
    photo_file_name "location.jpeg"
    sequence(:afip_url) { |n| "http://afip.something.com/ABCDEFGH#{n}" }
  end
end
