# frozen_string_literal: true

FactoryBot.define do
  factory :bus_stop do
    name { 'test_stop' }
    sequence :hastus_id
    trait :pending do
      name { 'Stop Name' }
      bench { 'PVTA bench' }
      curb_cut { 'Within 20 feet' }
      lighting { '20 - 50 feet' }
      mounting { 'Structure' }
      mounting_direction { 'Towards street' }
      schedule_holder { 'None' }
      shelter { 'Building' }
      sidewalk_width { 'Less than 36 inches' }
      trash { 'Municipal' }
      mounting_clearance { '60-83 inches' }
      sign_type { 'Rectangle (<2014)' }
      shelter_condition { 'Poor' }
      shelter_pad_condition { 'Great' }
      shelter_pad_material { 'Asphalt' }
      shelter_type { 'Modern half' }
      shared_sign_post_frta { false }
      need_work { '5 - Immediate safety concern' }
      obstructions { 'Yes - Bollard/Structure' }
      stop_sticker { 'Sticker correct' }
      route_stickers { 'No stickers' }
      bike_rack { 'Bike locker' }
      real_time_information { 'Yes - Solar' }
      created_at { 2.days.ago }
      updated_at { 1.day.ago }
      bolt_on_base { true }
      bus_pull_out_exists { true }
      has_power { true }
      solar_lighting { true }
      system_map_exists { true }
      shelter_ada_compliant { true }
      ada_landing_pad { true }
      state_road { true }
      accessible { true }
      # all attrs except for garage_responsible
    end
    trait :completed do
      pending
      garage_responsible { 'SATCo' }
      completed { true }
    end
  end
end
