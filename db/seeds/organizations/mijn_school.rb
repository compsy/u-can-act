organization_name = 'Mijn school'
teams = ['Mijn school']

puts "Running seeds for organization #{organization_name}"
organization = Organization.find_by_name(organization_name)
organization ||= Organization.create!(name: organization_name)

teams.each do |team|
  current_team = Team.find_by_name(team)
  current_team.update_attributes!(organization: organization)
end
