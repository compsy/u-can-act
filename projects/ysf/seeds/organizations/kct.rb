organization_name = 'KCT'
puts "Running seeds for organization #{organization_name}"
organization = Organization.find_by_name(organization_name)
organization ||= Organization.create!(name: organization_name)
