# frozen_string_literal: true

team_name = 'Mijn school'
titles = %w[PRO Stagebegeleider]

organization_name = 'Mijn school'
organization = Organization.find_by_name(organization_name)

puts "Running seeds for #{team_name}"
team = Team.find_by_name(team_name)
team ||= Team.create!(name: team_name, organization: organization)
team.update_attributes!(organization: organization)

student = team.roles.where(group: Person::STUDENT).first
student ||= team.roles.create!(group: Person::STUDENT, title: Person::STUDENT)

titles.each do |title|
  entry = team.roles.where(group: Person::MENTOR, title: title).first
  entry ||= team.roles.create!(group: Person::MENTOR, title: title)
end
