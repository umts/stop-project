FactoryBot.define do
  factory :user do
    sequence :name
    sequence(:email){ |n| "user#{n}@umass.edu" }
