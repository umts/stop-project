%w(setup deploy pending bundler rails passenger).each(&method(require))
Dir.glob('lib/capistrano/tasks/*.rake').each { |r| import r }
