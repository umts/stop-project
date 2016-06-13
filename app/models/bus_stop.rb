class BusStop < ActiveRecord::Base
  has_paper_trail
  validates :name, :hastus_id, presence: true
  default_scope -> { order :name }

  STRING_COLUMN_OPTIONS = {
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

  STRING_COLUMN_OPTIONS.each do |attribute, options|
    validates attribute, inclusion: { in: options }, allow_blank: true
  end
end
