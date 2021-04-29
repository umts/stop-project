# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence :name
    sequence(:email) { |n| "user#{n}@umass.edu" }
    password { 'Password1' }
    password_confirmation { 'Password1' }

    trait :admin do
      admin { true }
    end
  end
end
