team_name = 'KCT'

organization_name = 'Cross-sectional'
organization = Organization.find_by_name(organization_name)

puts "Running seeds for #{team_name}"
team = Team.find_by_name(team_name)
team ||= Team.create!(name: team_name, organization: organization)
team.update_attributes!(organization: organization)

student = team.roles.where(group: Person::OTHER).first
student ||= team.roles.create!(group: Person::OTHER, title: Person::OTHER)
