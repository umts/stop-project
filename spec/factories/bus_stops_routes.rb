# frozen_string_literal: true

FactoryBot.define do
  factory :bus_stops_route do
    sequence :sequence
    direction { 'North' }
    association :bus_stop
    association :route
  end
end
