# frozen_string_literal: true

team_name = 'Controlegroep'

organization_name = 'De Controlegroep'
organization = Organization.find_by(name: organization_name)

puts "Running seeds for #{team_name}"
team = Team.find_by(name: team_name)
team ||= Team.create!(name: team_name, organization: organization)
team.update!(organization: organization)

student = team.roles.where(group: Person::STUDENT).first
student ||= team.roles.create!(group: Person::STUDENT, title: Person::STUDENT)
