FactoryBot.define do
  factory :route do
    sequence(:number){ |n| "Route #{n}" }
    description 'route description'
    association :bus_stop
  end
end
