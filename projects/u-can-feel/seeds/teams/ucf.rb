# frozen_string_literal: true

team_name = 'UCF'

organization_name = 'UCF'
organization = Organization.find_by_name(organization_name)

puts "Running seeds for #{team_name}"
team = Team.find_by_name(team_name)
team ||= Team.create!(name: team_name, organization: organization)
team.update_attributes!(organization: organization)

title = 'School1'
entry = team.roles.where(group: Person::SOLO, title: title).first
entry ||= team.roles.create!(group: Person::SOLO, title: title)
