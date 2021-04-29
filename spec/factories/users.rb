# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence :name
    sequence(:email) { |n| "user#{n}@umass.edu" }
    password { 'PasswordPasswordPassword123!' }
    password_confirmation { 'PasswordPasswordPassword123!' }

    trait :admin do
      admin { true }
    end
  end
end
