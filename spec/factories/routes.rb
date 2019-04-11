# frozen_string_literal: true

FactoryBot.define do
  factory :route do
    sequence :number
    description { 'route description' }
  end
end
