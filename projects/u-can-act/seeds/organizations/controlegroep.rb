organization_name = 'De Controlegroep'
puts "Running seeds for organization #{organization_name}"
organization = Organization.find_by_name(organization_name)
organization ||= Organization.create!(name: organization_name)
