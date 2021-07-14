# frozen_string_literal: true

team_name = 'IKIA'

organization_name = 'IKIA'
organization = Organization.find_by(name: organization_name)

puts "Running seeds for #{team_name}"
team = Team.find_by(name: team_name)
team ||= Team.create!(name: team_name, organization: organization)
team.update!(organization: organization)

student_titles = %w[kids teens youngadults]
student_titles.each do |title|
  entry = team.roles.where(group: Person::STUDENT, title: title).first
  entry ||= team.roles.create!(group: Person::STUDENT, title: title)
end

mentor_titles = ['parents']
mentor_titles.each do |title|
  entry = team.roles.where(group: Person::MENTOR, title: title).first
  entry ||= team.roles.create!(group: Person::MENTOR, title: title)
end
