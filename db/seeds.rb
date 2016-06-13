User.create! name: 'David Faulkenberry',
             email: 'dave@example.com',
             password: 'password',
             password_confirmation: 'password',
             admin: true

User.create! name: 'George Boole',
             email: 'george@example.com',
             password: 'password',
             password_confirmation: 'password',
             admin: false

BusStop.create! name: 'Studio Arts Building',
                hastus_id: 72,
                accessible: 'When necessary',
                bench: 'PVTA',
                curb_cut: "Within 20'",
                lighting: "50\" - 20'",
                mounting: 'PVTA pole',
                mounting_direction: 'Towards street',
                shelter: 'PVTA',
                sidewalk: 'More than 36"',
                sign: nil,
                trash: 'Other',
                bus_pull_out_exists: true,
                has_power: true,
                system_map_exists: false
