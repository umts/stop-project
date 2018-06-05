FactoryBot.define do
  factory :route do
    sequence(:number){ |n| "Route #{n}" }
    description 'route description'
  end
end
