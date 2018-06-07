namespace :bus_stop_fields do
  task create: :environment do
    fields = {
      'Sign' => [ #remember rank
        { name: 'Stop sticker', column: :stop_sticker, field_type: :choice, choices: ['No sticker', 'Sticker incorrect', 'Sticker correct'] },
        { name: 'Route sticker', column: :route_sticker, field_type: :choice, choices: ['No sticker', 'Sticker incorrect', 'Sticker correct'] },
        { name: 'Mounting', column: :mounting, field_type: :choice, choices: ['PVTA pole', 'City pole', 'Utility pole', 'Structure', 'No sign'], description: 'Determine the mounting that a sign is on.' },
        { name: 'Shared sign post FRTA', column: :shared_sign_post_frta, field_type: :boolean, description: 'Are there other signs on the sign post?'},
        { name: 'Mounting direction', column: :mounting_direction, field_type: :choice, choices: ['Towards street', 'Away from street', 'Center', 'No sign'], description: 'The direction the sign face points.' },
        { name: 'Sign type', column: :sign_type, field_type: :choice, choices: ['Axehead', 'Rectangle', 'MGM + Axehead', 'Non-PVTA', 'No sign'], description: 'Determine the type of sign face.' },
        { name: 'Mounting clearance', column: :mounting_clearance, field_type: :choice, choices: ['No sign face', "Less than 60\"", "60-84\"", "Greater than 84\""], description: 'From the base of the sign to the ground.' },
        { name: 'Bolt on base', column: :bolt_on_base, field_type: :boolean, description: 'Is this a break away pole?' }
      ],
      'Accessible' => [ #remember rank
        { name: 'Accessible', column: :accessible, field_type: :boolean, description: 'Can this stop be safely accessed?' },
        { name: 'Curb cut', column: :curb_cut, field_type: :choice, choices: ["Within 20'", 'No curb cut', 'No curb'], description: 'Determine the border between the road and the bus stop.' },
        { name: 'Sidewalk width', column: :sidewalk_width, field_type: :choice, choices: ["More than 36\"", "Less than 36\"", 'None'], description: 'Determine if there is a sidewalk at the bus stop location or not. Note the size of the side walk as well.' },
        { name: 'Bus pull out exists', column: :bus_pull_out_exists, field_type: :boolean, description: 'Determine if there is a formal/constructed pull out in which a bus can pull in and out of.' },
        { name: 'ADA landing pad', column: :ada_landing_pad, field_type: :boolean, description: "Is there a concrete/brick/asphalt area that is unbostructed and a minimum of 5'x8'?" },
        { name: 'Obstructions', column: :obstructions, field_type: :choice, choices: ["Yes- tree/branches", "Yes- bollards/structure", "Yes - parking", "Yes - other", "No"], description: 'Are there any obstructions which make servicing this stop difficult?'}
      ],
     'Amenity' => [
       { name: 'Bench', column: :bench, field_type: :choice, choices: ['PVTA bench', 'Other bench', 'Other structure', 'PVTA and other bench', 'None'], description: 'Determine if the bus stop has a bench or area to sit.' },
       { name: 'Schedule holder', column: :schedule_holder, field_type: :choice, choices: ['On pole', 'In shelter', 'None'], description: 'Determine if there is a  bus schedule or not.' },
       { name: 'Trash', column: :trash, field_type: :boolean, description: "Determine if there is a trash receptacle at the stop or within 10' of the stop." },
       { name: 'System map exists', column: :system_map_exists, field_type: :choice, choices: ['New map', 'Old map', 'None'], description: 'Determine if there is a system map at this stop.' },
       { name: 'Bike rack', column: :bike_rack, field_type: :choice, choices: ['PVTA bike rack', 'Other bike rack', 'PVTA and other bike rack', 'None'], description: 'Determine if there are bike racks.' }
     ],
     'Info' => [
       { name: 'Completed', column: :completed, field_type: :boolean, description: 'Have all attributes been checked?' },
       { name: 'Garage responsible', column: :garage_responsible, field_type: :choice, choices: ['SATCo', 'UMTS', 'VATCo'] },
       { name: 'State road', column: :state_road, field_type: :boolean, description: 'Is this stop located on a state highway?' },
       { name: 'Needs work', column: :needs_work, field_type: :choice, choice: ['1- No issues','2- Needs cleaning; no safety concern', '3 - Minor issues; no safety concern', '4- Potential safety concern', '5- Immediate safety concern'], description: 'Rank on scale of 1 -5 if the stop needs work.' }
     ]
    }

    fields.each_pair do |category, category_fields|
      category_fields.each.with_index do |category_field, order|
        field = Field.create!(name: category_field.fetch(:name),
                              order: order,
                              category: category,
                              description: category_field.fetch(:description),
                              rank: category_field.fetch(:rank),
                              field_type: category_field.fetch(:field_type))
        BusStop.all.each do |stop|
          BusStopField.create! stop: stop, field: field, value: stop.send(category_field.fetch(:column))
        end
      end
    end

    BusStop.all.each do |stop|
      Field.all.each do |field|
        stop_field = field.name.to_sym
        BusStopField.create!(value: stop.send(stop_field))
    end
  end
end
