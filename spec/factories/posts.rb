FactoryGirl.define do
  factory :post do
    title "MyString"
    body "MyString"
    user
    published_at Date.yesterday
  end
end
