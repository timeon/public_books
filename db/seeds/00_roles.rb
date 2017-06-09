puts 'ROLES'
YAML.load(ENV['ROLES']).each do |role|
  Role.find_or_create_by name: role
  puts '  role: ' << role
end
