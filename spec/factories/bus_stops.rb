FactoryBot.define do
  factory :bus_stop do
    name 'stop'
    sequence(:hastus_id)
    association :routes, factory: :route
  end
end
