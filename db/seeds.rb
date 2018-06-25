require 'timecop'

User.create! name: 'David Faulkenberry',
             email: 'dave@example.com',
             password: 'password',
             password_confirmation: 'password',
             admin: true

User.create! name: 'Jake Foreman',
             email: 'jake@example.com',
             password: 'password',
             password_confirmation: 'password',
             admin: false

routes = {
  30 => Route.create!(number: '30', description: 'North Amherst / Old Belchertown Rd'),
  31 => Route.create!(number: '31', description: 'Sunderland / South Amherst'),
  38 => Route.create!(number: '38', description: 'UMass / Mount Holyoke College')
}

stops = {
  30 => ['Puffton Village', 'GRC', 'Cowles Ln', 'Colonial Village', 'Old Belchertown Rd', 'Amherst Post Office', 'Studio Arts Building'],
  31 => ['Sugarloaf Estates', 'Townhouse Apts', 'GRC', 'Cowles Ln', 'The Boulders', 'Amherst Post Office', 'Studio Arts Building'],
  38 => ['Haigis Mall', 'Cowles Ln', 'Amherst College', 'Hampshire College', 'Blanchard Hall']
}

hastus_ids = {
  'Amherst College'      => 116,
  'Amherst Post Office'  => 96,
  'Blanchard Hall'       => 336,
  'Colonial Village'     => 120,
  'Cowles Ln'            => 95,
  'GRC'                  => 58,
  'Haigis Mall'          => 73,
  'Hampshire College'    => 236,
  'Old Belchertown Rd'   => 148,
  'Puffton Village'      => 34,
  'Studio Arts Building' => 72,
  'Sugarloaf Estates'    => 9,
  'The Boulders'         => 157,
  'Townhouse Apts'       => 30
}

stops.each do |route_number, stop_names|
  stop_names.each do |stop_name|
    # Anytime in the last two months
    Timecop.freeze rand(86_400).minutes.ago do
      stop = BusStop.find_or_initialize_by name: stop_name
      stop.hastus_id = hastus_ids.fetch(stop_name)
      stop.routes << routes.fetch(route_number)
      stop.save!
    end
  end
end
