# frozen_string_literal: true

class BusStop < ApplicationRecord
  module Options
    SIGN = {
      sign_type: ['Axehead', 'Rectangle', 'MGM and Axehead', 'No sign', 'Non PVTA'],
      mounting: ['PVTA pole', 'City pole', 'Utility pole', 'Structure', 'No sign'],
      shared_sign_post_frta: :boolean,
      mounting_direction: ['Towards street', 'Away from street', 'Center', 'No sign'],
      mounting_clearance: ['Less than 60 inches', '60-84 inches', 'Greater than 84 inches', 'No sign face'],
      bolt_on_base: :boolean,
      stop_sticker: ['No sticker', 'Sticker incorrect', 'Sticker correct'],
      route_stickers: ['No stickers', 'Stickers incorrect', 'Stickers correct']
    }.freeze

    SHELTER = {
      shelter: ['No shelter', 'PVTA shelter', 'Other shelter', 'Nearby building'],
      shelter_type: ['Modern full', 'Modern half', 'Victorian', 'Dome', 'Wooden', 'Extra large', 'Other', 'No shelter'],
      shelter_ada_compliant: :boolean,
      shelter_condition: ['Great', 'Good', 'Fair', 'Poor', 'No shelter'],
      shelter_pad_condition: ['Great', 'Good', 'Fair', 'Poor', 'No shelter'],
      shelter_pad_material: ['Asphalt', 'Concrete', 'Other', 'No shelter']
    }.freeze

    AMENITIES = {
      bench: ['PVTA bench', 'Other bench', 'Other structure', 'PVTA and other bench', 'None'],
      bike_rack: ['PVTA bike rack', 'Other bike rack', 'PVTA and other bike rack', 'None'],
      schedule_holder: ['On pole', 'In shelter', 'None'],
      system_map_exists: ['New map', 'Old map', 'No map'],
      trash: :boolean
    }.freeze

    ACCESSIBILITY = {
      accessible: :boolean,
      curb_cut: ['Within 20 feet', 'No curb cut', 'No curb'],
      sidewalk_width: ['More than 36 inches', 'Less than 36 inches', 'None'],
      bus_pull_out_exists: :boolean,
      ada_landing_pad: :boolean,
      obstructions: ['Yes - Tree/Branch', 'Yes - Bollard/Structure', 'Yes - Sign/Post',
                     'Yes - Parking', 'Yes - Other', 'No']
    }.freeze

    SECURITY_AND_SAFETY = {
      lighting: ['Within 20 feet', '20 - 50 feet', 'None']
    }.freeze

    TECHNOLOGY = { solar_lighting: :boolean,
                   has_power: ['Yes - Stub up', 'Yes - Outlet', 'No'],
                   real_time_information: ['Yes - Solar', 'Yes - Power', 'No'] }.freeze

    COMBINED = {
      sign: SIGN,
      shelter: SHELTER,
      amenities: AMENITIES,
      accessibility: ACCESSIBILITY,
      security_and_safety: SECURITY_AND_SAFETY,
      technology: TECHNOLOGY
    }.freeze
  end
end
