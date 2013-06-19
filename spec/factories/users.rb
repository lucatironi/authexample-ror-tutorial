FactoryGirl.define do
  factory :user do

    trait :confirmed do
      confirmed_at Time.now
    end

    sequence(:email) { |n| "user#{n}@example.com" }
    sequence(:name) { |n| "user#{n}" }
    password 'testtest'
    password_confirmation 'testtest'
    confirmed

  end
end