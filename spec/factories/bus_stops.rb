# frozen_string_literal: true

FactoryBot.define do
  factory :bus_stop do
    name 'stop'
    sequence :hastus_id
    trait :pending do
      name 'not blank'
      bench
      curb_cut
      lighting
      mounting
      mounting_direction
      schedule_holder
      shelter
      sidewalk_width
      trash
      mounting_clearance
      sign_type
      shelter_condition
      shelter_pad_condition
      shelter_pad_material
      shelter_type
      shared_sign_post
      garage_responsible
      need_work
      obstructions
      stop_sticker
      route_stickers
      bike_rack
      real_time_information
      created_at Date.yesterday
      updated_at Date.today
      bolt_on_base true
      bus_pull_out_exists true
      has_power true
      solar_lighting true
      system_map_exists true
      shelter_ada_compliance true
      ada_landing_pad true
      state_road true
      # all attrs except for accessible
    end
    trait :completed do
      pending
      accessible true
      completed true
    end
  end
end
