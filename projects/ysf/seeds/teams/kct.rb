team_name = 'KCT'

organization_name = 'Cross-sectional'
organization = Organization.find_by(name: organization_name)
organization ||= Organization.create!(name: organization_name)

puts "Running seeds for #{team_name}"
team = Team.find_by(name: team_name)
team ||= Team.create!(name: team_name, organization: organization)
team.update_attributes!(organization: organization)

student = team.roles.where(group: Person::OTHER).first
student ||= team.roles.create!(group: Person::OTHER, title: Person::OTHER)
