# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :version do
    name "MVP Release"
    hipotesis "Everybody will love our app"
    blog_url "http://truestory.startmeapps.com"
    has_landing true
  end
end
