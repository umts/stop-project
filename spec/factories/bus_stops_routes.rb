# frozen_string_literal: true

FactoryBot.define do
  factory :bus_stops_route do
    sequence :sequence
    direction 'North'
  end
end
