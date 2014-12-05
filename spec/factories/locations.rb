# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :location do
    name "CrazyNight"
    address "102 Apple st."
    phone "1-101-1011"
    photo_file_name "thumb.jpeg"
    banner_file_name "banner.jpeg"
    description "This is a crazy place for a crazy night"
    capacity 1000
  end
end
