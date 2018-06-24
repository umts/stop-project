# frozen_string_literal: true

FactoryBot.define do
  factory :bus_stop do
    name 'stop'
    sequence :hastus_id
    trait :pending do
      name 'shit'
      sequence :hastus_id
      bench 'hi'
      curb_cut 'yo'
      lighting 'solar'
      mounting 'hi'
      mounting_direction 'shit'
      schedule_holder 'shit'
      shelter 'shit'
      sidewalk_width 'shit'
      trash 'to'
      mounting_clearance 'yeah'
      created_at Date.yesterday
      updated_at Date.today
      sign_type 'shit'
      shelter_condition 'good'
      shelter_pad_condition 'ugh'
      shelter_pad_material 'shit'
      shelter_type 'shit'
      shared_sign_post 'shit'
      garage_responsible 'UMTs'
      bike_rack 'shit'
      real_time_information 'shit'
      need_work 'shit'
      obstructions 'shit'
      stop_sticker 'shit'
      route_stickers 'shit'
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
