team_name = 'Differentiatie Binnenstebuiten'
titles = ['Docenten', 'Scholieren']

organization_name = 'Differentiatie Binnenstebuiten'
organization = Organization.find_by_name(organization_name)

puts "Running seeds for #{team_name}"
team = Team.find_by_name(team_name)
team ||= Team.create!(name: team_name, organization: organization)
team.update_attributes!(organization: organization)

titles.each do |title|
  entry = team.roles.where(group: Person::STUDENT, title: title).first
  entry ||= team.roles.create!(group: Person::STUDENT, title: title)
end
