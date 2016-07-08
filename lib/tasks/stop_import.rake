require 'csv'

#Change string column row names

STRING_COLUMN_ROW_NAMES = {
  accessible:         ['When necessary', 'Not recommended'                    ],
  bench:              ['PVTA',           'Other'                              ],
  curb_cut:           ["Within 20'",     'No curb cut',      'No curb'        ],
  lighting:           ['Within 50"',     "50\" - 20'",       'None'           ],
  mounting:           ['PVTA pole',      'Other pole',       'Structure'      ],
  mounting_direction: ['Towards street', 'Away from street'                   ],
  schedule_holder:    ['On pole',        'In shelter'                         ],
  shelter:            ['PVTA',           'Other',            'Building'       ],
  sidewalk:           ['More than 36"',  'Less than 36"',    'None'           ],
  sign:               ['Flag stop',      'Missing sign',     'Needs attention'],
  trash:              ['PVTA',           'Municipal',        'Other'          ]
}

COLUMN_NAMES = {

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
