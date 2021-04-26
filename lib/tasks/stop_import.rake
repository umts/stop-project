# frozen_string_literal: true

require 'csv'

# Example invocation: rake 'bus_stops:import[some_csv_file.csv]'

# rubocop:disable Layout/HashAlignment
# rubocop:disable Layout/SpaceInsideArrayPercentLiteral, Layout/SpaceInsidePercentLiteralDelimiters
STRING_COLUMN_ROW_NAMES = {
  accessible:      %w[stp_ud_accessible_when_necessary  stp_ud_accessible_not_recommended                            ],
  bench:           %w[stp_ud_bench_pvta_bench           stp_ud_bench_other_bench                                     ],
  curb_cut:        %w[stp_ud_curb_cut_drive_within_20ft stp_ud_curb_cut_no_curb_cut       stp_ud_curb_cut_no_curb    ],
  lighting:        %w[stp_ud_lighting_within_20ft       stp_ud_lighting_within_50ft       stp_ud_lighting_no_lighting],
  mounting:        %w[stp_ud_mounting_pvta_pole         stp_ud_mounting_pole_other        stp_ud_mounting_structure  ],
  schedule_holder: %w[stp_ud_schedule_holder_on_pole    stp_ud_schedule_holder_in_shelter                            ],
  shelter:         %w[stp_ud_shelter_pvta               stp_ud_shelter_other              stp_ud_shelter_building    ],
  sidewalk_width:  %w[stp_ud_sidewalk_more_than_36in    stp_ud_sidewalk_less_than_36in    stp_ud_sidewalk_no_sidewalk],
  trash:           %w[stp_ud_trash_pvta                 stp_ud_trash_municipal            stp_ud_trash_other         ]
}.freeze
# rubocop:enable Layout/HashAlignment
# rubocop:enable Layout/SpaceInsideArrayPercentLiteral, Layout/SpaceInsidePercentLiteralDelimiters

STRING_COLUMN_OPTIONS = {
  accessible: ['When necessary', 'Not recommended'],
  bench: %w[PVTA Other],
  curb_cut: ["Within 20'", 'No curb cut', 'No curb'],
  lighting: ["Within 20'", "20' - 50'", 'None'],
  mounting: ['PVTA pole', 'Other pole', 'City Pole', 'Utility Pole', 'Structure'],
  mounting_direction: ['Towards street', 'Away from street'],
  schedule_holder: ['On pole', 'In shelter'],
  shelter: %w[PVTA Other Building],
  shelter_condition: %w[Great Good Fair Poor],
  shelter_pad_condition: %w[Great Good Fair Poor],
  shelter_pad_material: %w[Asphalt Concrete Other],
  shelter_type: %w[Modern Modern\ half Victorian Dome Wooden Extra\ large Other],
  sidewalk_width: ['More than 36"', 'Less than 36"', 'None'],
  sign_type: ['Axehead (2014+)', 'Rectangle (<2014)', 'MGM + Axhead (2018+)'],
  trash: %w[PVTA Municipal Other]
}.freeze

COLUMN_NAMES = {
  hastus_id: 'stp_identifier',
  name: 'sloc_description',
  solar_lighting: 'stp_ud_lighting_solar',
  system_map_exists: 'stp_ud_system_map'
}.freeze

namespace :bus_stops do
  task :import, [:csv_file] => :environment do |_, args|
    BusStop.delete_all
    CSV.foreach(args[:csv_file], headers: true, col_sep: ';') do |row|
      attrs = {}
      STRING_COLUMN_ROW_NAMES.each do |attribute, column_names|
        column_names.each_with_index do |column_name, index|
          if row[column_name] == '1'
            attrs[attribute] = STRING_COLUMN_OPTIONS[attribute][index]
            break
          end
        end
      end
      COLUMN_NAMES.each do |db_column_name, csv_column_name|
        attrs[db_column_name] = row[csv_column_name]
      end
      next if attrs[:name].blank?

      BusStop.find_or_create_by attrs
    end
  end
end
