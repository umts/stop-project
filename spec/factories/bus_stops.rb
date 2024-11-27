# frozen_string_literal: true

FactoryBot.define do
  factory :bus_stop do
    name { 'Test Stop' }
    sequence(:hastus_id) { |n| "FAC-#{n}" }

    trait :pending do
      created_at { 2.days.ago }
      updated_at { 1.day.ago }
      state_road { true }
      needs_work { '5 - Immediate safety concern' }

      BusStop::Options::COMBINED.each_value do |hash|
        hash.each do |field, options|
          send(field) { options == :boolean ? true : options.first }
        end
      end
    end

    trait :completed do
      pending
      garage_responsible { 'SATCo' }
      completed { true }
    end
  end
end
