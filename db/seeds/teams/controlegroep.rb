team_name = 'Controlegroep'

puts "Running seeds for #{team_name}"
team = Team.find_by_name(team_name)
team ||= Team.create!(name: team_name)

student = team.roles.where(group: Person::STUDENT).first
student ||= team.roles.create!(group: Person::STUDENT, title: Person::STUDENT)
