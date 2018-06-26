# frozen_string_literal: true

FactoryBot.define do
  factory :bus_stop do
    name 'stop'
    sequence :hastus_id
    trait :pending do
      %i[name bench curb_cut lighting mounting mounting_direction
        schedule_holder shelter sidewalk_width trash mounting_clearance
        sign_type shelter_condition shelter_pad_condition shelter_pad_material
        shelter_type shared_sign_post garage_responsible need_work obstructions
        stop_sticker route_stickers bike_rack real_time_information].each do |s|
        send(s, 'not blank')
        end
      created_at Date.yesterday
      updated_at Date.today
      %i[bolt_on_base bus_pull_out_exists has_power solar_lighting
        system_map_exists shelter_ada_compliance ada_landing_pad
        state_road].each do |b|
        send(b, 'true')
        end
    # all attrs except for accessible
    end
    trait :completed do
      pending
      accessible true
      completed true
    end
  end
end
