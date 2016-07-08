require 'csv'

#Change string column row names

STRING_COLUMN_ROW_NAMES = {
  accessible:         %w(stp_ud_accessible_when_necessary  stp_ud_accessible_not_recommended),
  bench:              %w(stp_ud_bench_pvta_bench           stp_ud_bench_other_bench),
  curb_cut:           %w(stp_ud_curb_cut_drive_within_20ft stp_ud_curb_cut_no_curb_cut       stp_ud_curb_cut_no_curb    ),
  lighting:           %w(stp_ud_lighting_within_20ft       stp_ud_lighting_within_50ft       stp_ud_lighting_no_lighting),
  mounting:           %w(stp_ud_mounting_pvta_pole         stp_ud_mounting_pole_other        stp_ud_mounting_structure  ),
  schedule_holder:    %w(stp_ud_schedule_holder_on_pole    stp_ud_schedule_holder_in_shelter                            ),
  shelter:            %w(stp_ud_shelter_pvta               stp_ud_shelter_other              stp_ud_shelter_building    ),
  sidewalk:           %w(stp_ud_sidewalk_more_than_36in    stp_ud_sidewalk_less_than_36in    stp_ud_sidewalk_no_sidewalk),
  sign:               %w(stp_ud_sign_flag_stop             stp_ud_sign_missing               stp_ud_sign_needs_attention),
  trash:              %w(stp_ud_trash_pvta                 stp_ud_trash_municipal            stp_ud_trash_other         )
}

COLUMN_NAMES = {
  hastus_id:         'stp_identifier',
  name:              'sloc_description',
  solar_lighting:    'stp_ud_lighting_solar',
  system_map_exists: 'stp_ud_system_map'
}

namespace :bus_stops do
  task :import, [:csv_file] => :environment do |_, args|
    CSV.foreach(args[:csv_file], headers: true, col_sep: ';') do |row| 
      attrs = {}
      STRING_COLUMN_ROW_NAMES.stringify_keys.each do |attribute, row_names|
        row_names.each_with_index do |row_name, index|
          if row[attribute] == '1'
            attrs[attribute] = BusStop::STRING_COLUMN_OPTIONS[attribute][index]
            break
          end
        end
      end
      COLUMN_NAMES.stringify_keys.each do |db_column, csv_column|
        attrs[db_column] = row[csv_column]
      end
      BusStop.create! attrs
    end
  end
end
