team_name = 'Mijn school'
titles = ['PRO', 'Stagebegeleider']

puts "Running seeds for #{team_name}"
team = Team.find_by_name(team_name)
team ||= Team.create!(name: team_name)

student = team.roles.where(group: Person::STUDENT).first
student ||= team.roles.create!(group: Person::STUDENT, title: Person::STUDENT)

titles.each do |title|
  entry = team.roles.where(group: Person::MENTOR, title: title).first
  entry ||= team.roles.create!(group: Person::MENTOR, title: title)
end
